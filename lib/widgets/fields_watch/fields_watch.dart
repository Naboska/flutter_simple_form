import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

/// Similar to [SFormWatch], but subscribes exclusively to the field
/// and transmits to the [builder] the actual state of the form fields at
/// the time of changing the [fields].
class SFieldsWatch extends StatelessWidget {
  /// Fallback [SFormController] for the widget.
  final SFormController? controller;

  /// Observed fields.
  final Set<String>? fields;

  /// Called every time the [fields] are updated.
  final SFieldsWatchBuilder builder;

  const SFieldsWatch({
    Key? key,
    this.controller,
    this.fields,
    required this.builder,
  }) : super(key: key);

  /// The [Builder] subscribes to the [fields] change.
  @override
  Widget build(BuildContext context) {
    Widget result = Builder(builder: (context) {
      final controller = SFormProvider.of(context);

      SFormProvider.fieldsOf(context, fields ?? <String>{});

      return builder(context, controller.fields);
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
