import 'package:url_launcher/url_launcher.dart';

const officialLinks = <String, String>{
  'jdk': 'https://adoptium.net/temurin/releases/',
  'idea': 'https://www.jetbrains.com/idea/download/',
  'code': 'https://code.visualstudio.com/download',
  'fluent': 'https://bdlukaa.github.io/fluent_ui/',
};

Future<void> openOfficialLink(String key) async {
  final target = officialLinks[key];
  if (target == null) throw ArgumentError('Neznámý oficiální odkaz.');
  if (!await launchUrl(
    Uri.parse(target),
    mode: LaunchMode.externalApplication,
  )) {
    throw StateError('Prohlížeč se nepodařilo otevřít. Adresa: $target');
  }
}

Future<void> revealFolder(String path) async {
  if (!await launchUrl(
    Uri.directory(path),
    mode: LaunchMode.externalApplication,
  )) {
    throw StateError('Složku se nepodařilo otevřít: $path');
  }
}
