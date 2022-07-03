import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/types.dart';
import 'package:flutter_simple_form/utils/utils.dart';

import '../subjects/subjects.dart';

part 'form_controller.dart';
part 'form_fields_provider.dart';
part 'form_state_provider.dart';

class FormProvider extends StatefulWidget {
  final Widget child;
  final SFormController? controller;
  final SFormController Function()? create;

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

  static SFormController of(BuildContext context) {
    return _read<_FormStateProvider>(context).controller;
  }

  static SFormState stateOf(BuildContext context, {bool? watch}) {
    if (watch ?? true) {
      return _watch<_FormStateProvider>(context).controller.state;
    }

    return _read<_FormStateProvider>(context).controller.state;
  }

  static T _watch<T extends InheritedWidget>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<T>();

    assert(result != null, 'No $T found in context');

    return result!;
  }

  static T _read<T extends InheritedWidget>(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<T>();

    assert(result != null, 'No $T found in context');

    return result!.widget as T;
  }

  @override
  State<FormProvider> createState() => _FormProviderState();
}

class _FormProviderState extends State<FormProvider> {
  late final SFormController _formController;

  @override
  void initState() {
    final create = widget.create;
    _formController = create?.call() ?? widget.controller!;

    super.initState();
  }

  @override
  void dispose() {
    if (widget.create != null) _formController.dispose();

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
