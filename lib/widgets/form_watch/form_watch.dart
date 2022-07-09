import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

/// Notifies the builder of changes in the state of the form [SFormState]
/// and fields [SFormFieldState].
class SFormWatch extends StatelessWidget {
  /// Observed fields.
  final Set<String>? fields;

  /// Allows you to observe all fields, similarly [fields] = `<String>{}`.
  final bool watchAll;

  /// Called every time there are changes in the signed fields or form.
  final SFormWatchBuilder builder;

  const SFormWatch({
    Key? key,
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
    final controller = FormProvider.of(context);

    return Builder(builder: (context) {
      FormProvider.stateOf(context);

      if (fields != null || watchAll) {
        FormProvider.fieldsOf(context, fields ?? <String>{});
      }

      return builder(context, controller);
    });
  }
}
