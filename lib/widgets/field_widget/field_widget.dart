import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

abstract class SFieldWidget<T> extends StatefulWidget {
  final String name;

  const SFieldWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  @protected
  @override
  SFieldState<T> createState();
}

abstract class SFieldState<T> extends State<SFieldWidget<T>>
    implements SFieldProxy<T> {
  /// Form controller.
  late final SFormController _controller;

  /// Field with dynamic [SFormFieldState].
  late final SFormFieldSubject _field;

  /// Proxy for [SFormFieldSubject.state].
  @override
  SFormFieldState<T> get state {
    final state = _field.state;

    return SFormFieldState<T>(
      value: state.value,
      errorMessage: state.errorMessage,
      isDirty: state.isDirty,
      isTouched: state.isTouched,
    );
  }

  /// Proxy for [SFormController.state].
  SFormState get formState => _controller.state;

  @override
  void initState() {
    super.initState();

    _controller = FormProvider.of(context);
    _field = _controller.register(widget.name)..addListener(_notify);
    _controller.stateSubject.addListener(_notify);
  }

  @override
  void dispose() {
    _field.removeListener(_notify);
    _controller.stateSubject.removeListener(_notify);

    super.dispose();
  }

  void _notify() => setState(() {});

  /// Proxy for [SFormFieldSubject.setValue].
  @override
  void setValue(T? newValue) => _field.setValue(newValue);

  /// Proxy for [SFormFieldSubject.touch].
  @override
  void touch() => _field.touch();

  /// Proxy for [SFormFieldSubject.setError].
  @override
  void setError(String? message) => _field.setError(message);

  /// Proxy for [SFormFieldSubject.reset].
  @override
  void reset() => _field.reset();
}
