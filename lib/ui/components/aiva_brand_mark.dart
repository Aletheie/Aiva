import 'package:fluent_ui/fluent_ui.dart';

class AivaBrandMark extends StatelessWidget {
  const AivaBrandMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Logo Aiva',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
      ),
    ),
  );
}
