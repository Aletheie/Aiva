import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';

class LessonLinks extends InheritedWidget {
  const LessonLinks({
    super.key,
    required this.controller,
    required super.child,
  });
  final AppController controller;

  static AppController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LessonLinks>()?.controller;

  @override
  bool updateShouldNotify(LessonLinks oldWidget) =>
      controller != oldWidget.controller;
}
