import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

/// Similar to [SFormWatch], but subscribes exclusively to the field
/// and transmits to the [builder] the actual state of the form fields at
/// the time of changing the [fields].
class SFieldsWatch extends StatelessWidget {
  /// Observed fields.
  final Set<String> fields;

  /// Called every time the [fields] are updated.
  final SFieldsWatchBuilder builder;

  const SFieldsWatch({
    Key? key,
    required this.fields,
    required this.builder,
  }) : super(key: key);

  /// The [Builder] subscribes to the [fields] change.
  @override
  Widget build(BuildContext context) {
    final controller = FormProvider.of(context);

    return Builder(builder: (context) {
      FormProvider.fieldsOf(context, fields);

      return builder(context, controller.fields);
    });
  }
}
