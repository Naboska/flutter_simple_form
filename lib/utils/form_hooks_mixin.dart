import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

/// Provides easy access to change subscriptions in the form.
mixin SFormHooksMixin<T extends StatefulWidget> on State<T> {
  late final SWatchController _watchController;

  SFormController get form => SFormProvider.of(context);

  @override
  void initState() {
    super.initState();

    _watchController = SWatchController(context);
  }

  @override
  void dispose() {
    _watchController.dispose();

    super.dispose();
  }

  /// See [SWatchController.watch].
  ///
  /// Use only inside [State.initState].
  void useWatchEffect(SWatchListener listener, Set<String> fields) {
    _watchController.watch(fields, listener);
  }

  /// See [SWatchController.watchAll].
  ///
  /// Use only inside [State.initState].
  void useWatchAllEffect(SWatchListener listener) {
    _watchController.watchAll(listener);
  }

  /// See [SFormProvider.stateOf].
  ///
  /// Use only inside [State.build].
  SFormState useFormState() {
    return SFormProvider.stateOf(context, true);
  }

  /// See [SFormProvider.valuesOf].
  ///
  /// Use only inside [State.build].
  SFormValues useFormValues([Set<String>? fields]) {
    return SFormProvider.valuesOf(context, fields);
  }

  /// See [SFormProvider.fieldsOf].
  ///
  /// Use only inside [State.build].
  SFormFields useFormFields([Set<String>? fields]) {
    return SFormProvider.fieldsOf(context, fields);
  }
}
