part of 'form_provider.dart';

class _FormStateProvider extends InheritedNotifier {
  final SFormController controller;

  _FormStateProvider({
    required this.controller,
    required super.child,
  }) : super(notifier: controller.stateSubject);
}
