import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

/// Notifies the builder of changes in the state of the form [SFormState]
/// and fields [SFormFieldState].
class SFormWatch extends StatelessWidget {
  /// Fallback [SFormController] for the widget.
  final SFormController? controller;

  /// Observed fields.
  final Set<String>? fields;

  /// Allows you to observe all fields, similarly [fields] = `<String>{}`.
  final bool watchAll;

  /// Called every time there are changes in the signed fields or form.
  final SFormWatchBuilder builder;

  const SFormWatch({
    Key? key,
    this.controller,
    this.fields,
    this.watchAll = false,
    required this.builder,
  })  : assert((fields == null && !watchAll) ||
            (fields != null && !watchAll) ||
            (fields == null && watchAll)),
        super(key: key);

  /// The [Builder] subscribes to the form change, and if necessary
  /// to the fields.
  @override
  Widget build(BuildContext context) {
    Widget result = Builder(builder: (context) {
      final controller = SFormProvider.of(context);

      SFormProvider.stateOf(context);

      if (fields != null || watchAll) {
        SFormProvider.fieldsOf(context, fields ?? <String>{});
      }

      return builder(context, controller);
    });

    if (controller != null) {
      result = SFormProvider(
        controller: controller,
        child: result,
      );
    }

    return result;
  }
}
