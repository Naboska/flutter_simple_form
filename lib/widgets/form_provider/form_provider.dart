import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'form_controller.dart';
part 'form_fields_provider.dart';
part 'form_state_provider.dart';

/// Inherited provider for [SFormController].
///
/// Implements methods for subscribing to changing values [SFormState]
/// and fields [SFormFieldState].
class FormProvider extends StatefulWidget {
  /// Child for the provider, can accept any [Widget].
  final Widget child;

  /// The [SFormController] you created, you need to close it yourself.
  ///
  /// You cannot put the [controller] at the same time with [create].
  final SFormController? controller;

  /// The creator function for the [SFormController], its closure is guaranteed
  /// by the [FormProvider] after destruction from the tree.
  ///
  /// You can't put a [create] at the same time with [controller].
  final SFormControllerCreate? create;

  const FormProvider({
    super.key,
    required this.child,
    this.controller,
    this.create,
  })  : assert(controller != null || create != null,
            'you need to create a SFormController'),
        assert(
            (controller == null && create != null) ||
                (controller != null && create == null),
            'you need to choose one thing, either the controller or the create');

  /// Retrieves the controller from the context without
  /// subscribing to its changes.
  static SFormController of(BuildContext context) {
    return _read<_FormStateProvider>(context).controller;
  }

  /// Gets the current state of the form [SFormState].
  ///
  /// Can be a subscription if [watch] will be equal to `true`.
  ///
  /// If [watch] is `null`, then it will be considered as `true`.
  static SFormState stateOf(BuildContext context, [bool? watch]) {
    if (watch ?? true) {
      return _watch<_FormStateProvider>(context).controller.state;
    }

    return _read<_FormStateProvider>(context).controller.state;
  }

  /// Subscribes to changing fields, if you do
  /// not pass the fields [SFormFields], it will receive all changes.
  static SFormFields fieldsOf(BuildContext context, [Set<String>? fields]) {
    final result = _watch<_FormFieldsProvider>(context, fields ?? <String>{});

    return result.controller.fields;
  }

  /// Similar to method [fieldsOf], but will return only values [SFormValues].
  static SFormValues valuesOf(BuildContext context, [Set<String>? fields]) {
    final result = _watch<_FormFieldsProvider>(context, fields ?? <String>{});

    return result.controller.values;
  }

  /// Internal method, subscribes to the change of the [InheritedWidget]
  /// from the [BuildContext].
  static T _watch<T extends InheritedWidget>(
    BuildContext context, [
    Set<String>? asp,
  ]) {
    final result = context.dependOnInheritedWidgetOfExactType<T>(aspect: asp);
    assert(result != null, 'No $T found in context');

    return result!;
  }

  /// Internal method, gets the [InheritedWidget] from the [BuildContext].
  static T _read<T extends InheritedWidget>(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<T>();
    assert(result != null, 'No $T found in context');

    return result!.widget as T;
  }

  @override
  State<FormProvider> createState() => _FormProviderState();
}

class _FormProviderState extends State<FormProvider> {
  /// The form provider created or forwarded will be created only once.
  late final SFormController _formController;
  late final bool _isCreated;

  @override
  void initState() {
    _isCreated = widget.create != null;
    _formController = widget.create?.call(context) ?? widget.controller!;

    super.initState();
  }

  @override
  void dispose() {
    if (_isCreated) _formController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormStateProvider(
      controller: _formController,
      child: _FormFieldsProvider(
        controller: _formController,
        child: widget.child,
      ),
    );
  }
}
