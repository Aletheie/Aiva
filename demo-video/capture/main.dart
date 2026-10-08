// Capture-only entrypoint. The production application sources stay untouched.
// Exports Aiva's own render tree; never reads the desktop or other applications.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:aiva/app/aiva_app.dart';
import 'package:aiva/main.dart' show loadApplication;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

final boundaryKey = GlobalKey();
final recorder = AppRecorder();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await loadApplication();
  runApp(RepaintBoundary(key: boundaryKey, child: AivaApp(controller: app)));
  unawaited(app.detectTools());
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 9891);
  await for (final request in server) {
    try {
      Object result;
      switch (request.uri.path) {
        case '/start':
          final body = jsonDecode(await utf8.decoder.bind(request).join()) as Map;
          result = await recorder.start(body['output'] as String);
        case '/stop':
          result = await recorder.stop();
        case '/still':
          final path = request.uri.queryParameters['path']!;
          final image = await recorder.snapshot();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          await File(path).writeAsBytes(bytes!.buffer.asUint8List());
          result = {'path': path};
        default:
          result = {'recording': recorder.active, 'frames': recorder.frames};
      }
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(result));
    } catch (error, stack) {
      request.response.statusCode = 500;
      request.response.write('$error\n$stack');
    }
    await request.response.close();
  }
}

class AppRecorder {
  bool active = false;
  int frames = 0;
  int duplicateFrames = 0;
  Process? encoder;
  Future<void>? loop;
  final clock = Stopwatch();
  late String output;
  late int startedAt;
  final errors = StringBuffer();

  Future<ui.Image> snapshot() async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary = boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    return boundary.toImage(pixelRatio: 2);
  }

  Future<Map<String, Object>> start(String path) async {
    if (active) throw StateError('Already recording');
    if (File(path).existsSync()) throw StateError('Refusing to overwrite $path');
    output = path;
    await File(path).parent.create(recursive: true);
    final initial = await snapshot();
    final width = initial.width;
    final height = initial.height;
    initial.dispose();
    encoder = await Process.start('/usr/local/bin/ffmpeg', [
      '-hide_banner', '-loglevel', 'warning', '-f', 'rawvideo', '-pixel_format', 'rgba',
      '-video_size', '${width}x$height', '-framerate', '30', '-i', 'pipe:0',
      '-an', '-c:v', 'libx264', '-preset', 'ultrafast', '-crf', '13',
      '-pix_fmt', 'yuv420p', '-movflags', '+faststart', path,
    ]);
    encoder!.stderr.transform(utf8.decoder).listen(errors.write);
    encoder!.stdout.drain<void>();
    frames = 0;
    duplicateFrames = 0;
    startedAt = DateTime.now().microsecondsSinceEpoch;
    clock.reset();
    clock.start();
    active = true;
    loop = record();
    return {'startedAt': startedAt, 'width': width, 'height': height, 'fps': 30};
  }

  Future<void> record() async {
    List<int>? previous;
    while (active) {
      final image = await snapshot();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      final current = bytes!.buffer.asUint8List();
      final target = (clock.elapsedMicroseconds * 30 / 1000000).floor();
      while (previous != null && frames < target) {
        encoder!.stdin.add(previous);
        frames++;
        duplicateFrames++;
      }
      encoder!.stdin.add(current);
      await encoder!.stdin.flush();
      previous = current;
      frames++;
      final wait = (frames * 1000000 / 30).round() - clock.elapsedMicroseconds;
      if (wait > 0) await Future<void>.delayed(Duration(microseconds: wait));
    }
  }

  Future<Map<String, Object>> stop() async {
    if (!active) throw StateError('Not recording');
    active = false;
    await loop;
    clock.stop();
    await encoder!.stdin.close();
    final code = await encoder!.exitCode;
    final metadata = {'output': output, 'startedAt': startedAt, 'frames': frames,
      'duplicateFrames': duplicateFrames, 'duration': frames / 30,
      'elapsed': clock.elapsedMicroseconds / 1000000, 'encoderExitCode': code,
      'encoderLog': errors.toString()};
    await File('$output.json').writeAsString(const JsonEncoder.withIndent('  ').convert(metadata));
    if (code != 0) throw StateError('Encoder failed: $metadata');
    return metadata;
  }
}
