import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

Future<void> showDependencyLicenses(BuildContext context) async {
  final entries = LicenseRegistry.licenses.toList();
  await showDialog<void>(
    context: context,
    builder: (context) => ContentDialog(
      constraints: const BoxConstraints(maxWidth: 880, maxHeight: 800),
      title: const Text('Licence závislostí'),
      content: FutureBuilder<List<LicenseEntry>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SelectableText(
              'Licence se nepodařilo načíst: ${snapshot.error}',
            );
          }
          if (!snapshot.hasData) return const Center(child: ProgressRing());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final entry = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Expander(
                  header: Text(entry.packages.join(', ')),
                  content: SelectableText(
                    entry.paragraphs.map((p) => p.text).join('\n\n'),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zavřít'),
        ),
      ],
    ),
  );
}
