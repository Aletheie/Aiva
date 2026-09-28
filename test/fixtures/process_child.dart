// Invoked by ProcessRunner tests as a real standalone Dart process.
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  switch (args.first) {
    case 'echo':
      final input = await stdin.transform(utf8.decoder).join();
      stdout.write(input);
      stderr.write('diagnostika: žluťoučký');
    case 'args':
      stdout.write(jsonEncode(args.skip(1).toList()));
    case 'fail':
      stderr.write('intentional failure');
      exitCode = 7;
    case 'sleep':
      await Future<void>.delayed(const Duration(seconds: 30));
    case 'flood':
      for (var i = 0; i < 1000; i++) {
        stdout.write(List.filled(1024, 'x').join());
      }
    default:
      throw ArgumentError('Unknown child mode');
  }
}
