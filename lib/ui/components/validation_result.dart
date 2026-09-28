import 'package:fluent_ui/fluent_ui.dart';
import '../../services/exercise_runner.dart';
import 'code_block.dart';

class ValidationResult extends StatelessWidget {
  const ValidationResult({super.key, required this.report});
  final ValidationReport report;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        liveRegion: true,
        child: InfoBar(
          title: Text(report.message),
          isLong: true,
          severity: report.passed
              ? InfoBarSeverity.success
              : report.status == CheckStatus.cancelled
              ? InfoBarSeverity.info
              : InfoBarSeverity.warning,
        ),
      ),
      if (report.diagnostics.isNotEmpty) ...[
        const SizedBox(height: 12),
        Expander(
          initiallyExpanded: !report.passed,
          header: const Text('Podrobnosti kontroly'),
          content: CodeBlock(
            code: report.diagnostics,
            language: 'text',
            caption: 'Hlášení nástroje',
          ),
        ),
      ],
      if (report.cases.isNotEmpty) ...[
        const SizedBox(height: 12),
        Expander(
          initiallyExpanded: !report.passed,
          header: Text(
            'Testy: ${report.cases.where((item) => item.passed).length} / ${report.totalCases} prošlo',
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final result in report.cases)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Expander(
                    initiallyExpanded: !result.passed,
                    header: Text(
                      'Test ${result.number} · ${result.passed
                          ? 'V pořádku'
                          : result.problem != null
                          ? 'Běh nedokončen'
                          : 'Výstup se liší'}',
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (result.problem case final problem?) Text(problem),
                        if (result.input.isEmpty)
                          const Text('Bez vstupu.')
                        else
                          CodeBlock(
                            code: result.input,
                            language: 'text',
                            caption: 'Vstup (Input)',
                          ),
                        CodeBlock(
                          code: result.expected,
                          language: 'text',
                          caption: 'Očekávaný výstup (Expected output)',
                        ),
                        if (!result.passed)
                          CodeBlock(
                            code: result.actual,
                            language: 'text',
                            caption: 'Tvůj výstup (Actual output)',
                          ),
                        if (result.stderr.isNotEmpty)
                          CodeBlock(
                            code: result.stderr,
                            language: 'text',
                            caption: 'Chybový výstup (Standard error)',
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ],
  );
}
