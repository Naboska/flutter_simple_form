import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

typedef TFieldWidgetBuilder<T> = Widget Function(SFieldState<T, SFieldWidget<T>> field);

abstract class SFieldWidget<T> extends StatefulWidget {
  /// Form field name.
  final String name;

  /// Form field widget builder.
  final TFieldWidgetBuilder? builder;

  const SFieldWidget({
    super.key,
    required this.name,
    this.builder,
  });

  @protected
  @override
  SFieldState<T, SFieldWidget<T>> createState();
}

abstract class SFieldState<T, W extends SFieldWidget<T>> extends State<W>
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
    _field = _controller.register(widget.name)..addListener(notify);
    _controller.stateSubject.addListener(notify);
  }

  @override
  void dispose() {
    _field.removeListener(notify);
    _controller.stateSubject.removeListener(notify);

    super.dispose();
  }

  /// Notifies about a field change.
  @mustCallSuper
  void notify() => setState(() {});

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

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) return widget.builder!(this);

    throw UnimplementedError();
  }
}
