import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart' as fw show RadioGroup;
import 'package:file_selector/file_selector.dart';
import '../../app/app_controller.dart';
import '../../platform/external_links.dart';
import '../components/dialogs.dart';
import '../components/licenses_dialog.dart';
import '../components/surfaces.dart';
import '../design.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.controller});
  final AppController controller;

  Future<void> _pickDirectory(
    Future<void> Function(String) use,
    String label,
  ) => controller.guard(() async {
    final path = await getDirectoryPath(confirmButtonText: label);
    if (path != null) await use(path);
  });

  Future<void> _pickEditor() => controller.guard(() async {
    final file = await openFile(confirmButtonText: 'Vybrat editor');
    if (file != null) await controller.chooseEditor(file.path);
  });

  Future<void> _backup() => controller.guard(() async {
    final destination = await getSaveLocation(
      suggestedName:
          'aiva-${DateTime.now().toIso8601String().substring(0, 10)}.sqlite',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Záloha Aiva', extensions: ['sqlite', 'db']),
      ],
    );
    if (destination != null) await controller.backup(destination.path);
  });

  Future<void> _import(BuildContext context) => controller.guard(() async {
    final source = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Záloha Aiva',
          extensions: ['sqlite', 'db', 'sqlite3'],
        ),
      ],
    );
    if (source == null || !context.mounted) return;
    final confirmed = await confirmAction(
      context,
      title: 'Importovat postup ze zálohy?',
      message:
          'Dokončené lekce, cvičení a oblíbené se přidají k současnému profilu. '
          'Tvoje nastavení se zachová. Před importem vznikne záloha. '
          'Soubory s řešením se nepřesouvají.',
      action: 'Importovat',
    );
    if (confirmed) await controller.importProfile(source.path);
  });

  @override
  Widget build(BuildContext context) => PageScroll(
    maxWidth: 920,
    children: [
      const PageTitle(
        title: 'Nastavení',
        subtitle: 'Vzhled aplikace, nástroje pro cvičení a uložená data.',
      ),
      Expander(
        initiallyExpanded: true,
        leading: const Icon(FluentIcons.color, size: 18),
        header: const Text('Vzhled'),
        content: _Appearance(controller: controller),
      ),
      const SizedBox(height: 12),
      Expander(
        key: const ValueKey('settings-tools'),
        leading: const Icon(FluentIcons.code, size: 18),
        header: const Text('Java a editor'),
        content: _tools(context),
      ),
      const SizedBox(height: 12),
      Expander(
        leading: const Icon(FluentIcons.fabric_folder, size: 18),
        header: const Text('Soubory cvičení a spouštění'),
        content: _workspace(context),
      ),
      const SizedBox(height: 12),
      Expander(
        leading: const Icon(FluentIcons.save, size: 18),
        header: const Text('Data a zálohy'),
        content: _data(context),
      ),
      const SizedBox(height: 12),
      Expander(
        leading: const Icon(FluentIcons.info, size: 18),
        header: const Text('O aplikaci'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aiva', style: FluentTheme.of(context).typography.subtitle),
            const SizedBox(height: 8),
            const Text(
              'Český kurz Javy. Lekce i postup jsou uložené na tomto zařízení.',
            ),
            const SizedBox(height: 16),
            Button(
              onPressed: () => showDependencyLicenses(context),
              child: const Text('Licence'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _tools(BuildContext context) {
    final app = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Pro kontrolu cvičení vyber JDK 21 nebo novější. Pro čtení lekcí ho nepotřebuješ.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(
              onPressed: app.detecting ? null : app.detectTools,
              child: Text(app.detecting ? 'Hledám…' : 'Vyhledat nástroje'),
            ),
            HyperlinkButton(
              onPressed: () => app.openReference('jdk-and-ide'),
              child: const Text('Jak připravit Javu a editor'),
            ),
          ],
        ),
        if (app.detecting) ...[const SizedBox(height: 16), const ProgressBar()],
        const SizedBox(height: 20),
        Text(
          'Vývojová sada (JDK)',
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        const SizedBox(height: 12),
        if (app.tools.jdks.isEmpty && !app.detecting)
          const Text(
            'JDK zatím není vybrané. Vyhledej instalaci nebo vyber její složku.',
          ),
        fw.RadioGroup<String>(
          groupValue: app.selectedJdk?.home,
          onChanged: (value) {
            if (value != null) app.preference('jdkHome', value);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final jdk in app.tools.jdks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RadioButton<String>(
                    value: jdk.home,
                    content: Text(jdk.label),
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(
              onPressed: () => _pickDirectory(app.chooseJdk, 'Vybrat JDK'),
              child: const Text('Vybrat složku JDK'),
            ),
            HyperlinkButton(
              onPressed: () => app.guard(() => openOfficialLink('jdk')),
              child: const Text('Stáhnout JDK Temurin'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Editor kódu (IDE)',
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        const SizedBox(height: 12),
        if (app.tools.editors.isEmpty)
          const Text(
            'Vyber aplikaci, ve které budeš upravovat soubory cvičení.',
          ),
        fw.RadioGroup<String>(
          groupValue: app.selectedEditor?.path,
          onChanged: (value) {
            if (value != null) app.chooseEditor(value);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final editor in app.tools.editors)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RadioButton<String>(
                    value: editor.path,
                    content: Text(editor.name),
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(
              onPressed: Platform.isMacOS
                  ? () => _pickDirectory(app.chooseEditor, 'Vybrat aplikaci')
                  : _pickEditor,
              child: const Text('Vybrat editor'),
            ),
            HyperlinkButton(
              onPressed: () => app.guard(() => openOfficialLink('idea')),
              child: const Text('IntelliJ IDEA'),
            ),
            HyperlinkButton(
              onPressed: () => app.guard(() => openOfficialLink('code')),
              child: const Text('Visual Studio Code'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expander(
          header: const Text('Zadat cesty ručně'),
          content: Column(
            children: [
              _PathEntry(
                label: 'Složka JDK (JAVA_HOME)',
                value: app.profile.setting('jdkHome'),
                hint: Platform.isMacOS
                    ? '/Library/Java/JavaVirtualMachines/…/Contents/Home'
                    : 'Složka obsahující bin/java',
                onSubmit: app.chooseJdk,
              ),
              const SizedBox(height: 16),
              _PathEntry(
                label: Platform.isMacOS
                    ? 'Aplikace editoru (.app)'
                    : 'Spustitelný soubor editoru',
                value: app.profile.setting('editorPath'),
                hint: Platform.isMacOS
                    ? '/Applications/IntelliJ IDEA.app'
                    : 'Například Code.exe',
                onSubmit: app.chooseEditor,
              ),
            ],
          ),
        ),
        if (app.tools.notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          Expander(
            header: const Text('Podrobnosti hledání'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final note in app.tools.notes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SelectableText(note),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _workspace(BuildContext context) {
    final app = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Pracovní složka (Workspace)'),
        const SizedBox(height: 8),
        SelectableText(
          app.workspaceRoot,
          style: TextStyle(fontFamily: Design.mono, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(
              onPressed: app.isRunning
                  ? null
                  : () => _pickDirectory(
                      (path) => app.preference('workspace', path),
                      'Vybrat pracovní složku',
                    ),
              child: const Text('Změnit složku'),
            ),
            Button(
              onPressed: () => app.guard(() async {
                await Directory(app.workspaceRoot).create(recursive: true);
                await revealFolder(app.workspaceRoot);
              }),
              child: const Text('Otevřít složku'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Změnou cesty se existující soubory nepřesunou.',
          style: TextStyle(color: Design.muted(context)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Spouštění vlastního kódu',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          app.executionConsent
              ? 'Spouštění je povolené.'
              : 'Při první kontrole požádáme o souhlas.',
        ),
        const SizedBox(height: 8),
        const Text(
          'Java programy běží s přístupem k tvým souborům a síti. Nejsou izolované v odděleném prostředí (sandbox).',
        ),
        if (app.executionConsent) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              onPressed: () => app.preference('executionConsent', 'no'),
              child: const Text('Zrušit souhlas'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _data(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Záloha obsahuje postup a nastavení. Soubory s Java kódem zůstávají v pracovní složce.',
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          Button(onPressed: _backup, child: const Text('Vytvořit zálohu')),
          Button(
            onPressed: controller.isRunning ? null : () => _import(context),
            child: const Text('Importovat zálohu'),
          ),
          Button(
            onPressed: () =>
                controller.guard(() => revealFolder(controller.paths.profile)),
            child: const Text('Otevřít složku profilu'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      SelectableText(
        controller.paths.database,
        style: TextStyle(fontFamily: Design.mono, fontSize: 12),
      ),
    ],
  );
}

class _Appearance extends StatelessWidget {
  const _Appearance({required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final app = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(
          label: 'Barevný režim',
          child: fw.RadioGroup<String>(
            groupValue: app.profile.setting('theme', 'system'),
            onChanged: (value) {
              if (value != null) app.preference('theme', value);
            },
            child: Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                for (final option in const {
                  'system': 'Podle systému',
                  'light': 'Světlý',
                  'dark': 'Tmavý',
                }.entries)
                  RadioButton<String>(
                    value: option.key,
                    content: Text(option.value),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        InfoLabel(
          label: 'Velikost textu',
          child: ComboBox<int>(
            value: (app.textScale * 100).round(),
            items: [
              for (final size in const [90, 100, 110, 125, 150, 160])
                ComboBoxItem(value: size, child: Text('$size %')),
            ],
            onChanged: (value) {
              if (value != null) app.preference('uiScale', '$value');
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Zvětšení se přidává k nastavení textu v systému.',
          style: TextStyle(color: Design.muted(context)),
        ),
        const SizedBox(height: 24),
        ToggleSwitch(
          checked: app.acrylic,
          onChanged: (value) => app.preference('acrylic', value ? 'yes' : 'no'),
          content: const Flexible(child: Text('Průhledná navigace (Acrylic)')),
        ),
        const SizedBox(height: 16),
        ToggleSwitch(
          checked: app.reducedMotion,
          onChanged: (value) =>
              app.preference('reducedMotion', value ? 'yes' : 'no'),
          content: const Flexible(child: Text('Omezit animace')),
        ),
      ],
    );
  }
}

class _PathEntry extends StatefulWidget {
  const _PathEntry({
    required this.label,
    required this.value,
    required this.hint,
    required this.onSubmit,
  });
  final String label;
  final String value;
  final String hint;
  final Future<void> Function(String) onSubmit;
  @override
  State<_PathEntry> createState() => _PathEntryState();
}

class _PathEntryState extends State<_PathEntry> {
  late final TextEditingController _text;
  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_PathEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _text.text = widget.value;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InfoLabel(
    label: widget.label,
    child: Row(
      children: [
        Expanded(
          child: TextBox(
            controller: _text,
            placeholder: widget.hint,
            onSubmitted: (value) => widget.onSubmit(value.trim()),
          ),
        ),
        const SizedBox(width: 12),
        Button(
          onPressed: () => widget.onSubmit(_text.text.trim()),
          child: const Text('Použít'),
        ),
      ],
    ),
  );
}
