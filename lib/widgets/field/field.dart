import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

/// Creating and managing a field.
///
/// Creates a new field if it is not registered.
///
/// ### Example
///
/// ```dart
/// class ColorField extends StatelessWidget {
///   const ColorField({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return SField<Color>(
///       name: 'color',
///       builder: (context, field, formState) {
///         final color = field.state.value;
///
///         return GestureDetector(
///           onTap: () {
///             const white = Color(0xFFFFFFFF);
///
///             field.setValue(color == white ? const Color(0xFF000000) : white);
///             field.touch();
///           },
///           child: Container(
///             width: 100,
///             height: 100,
///             color: color ?? const Color(0xFF424242),
///           ),
///         );
///       },
///     );
///   }
/// }
/// ```
class SField<T> extends StatelessWidget {
  /// Name of the field in the form.
  final String name;

  /// Builder for the widget. In the arguments in order:
  /// [BuildContext], [SFieldProxy], [SFormState].
  final SFieldBuilder<T> builder;

  const SField({
    Key? key,
    required this.name,
    required this.builder,
  }) : super(key: key);

  /// Internal method.
  ///
  /// Registers or retrieves an existing field and
  /// returns a [SFieldProxy] for management.
  SFieldProxy<T> _getProxyField(BuildContext context) {
    final controller = FormProvider.of(context);
    final field = controller.register(name);

    return SFieldProxy<T>(field);
  }

  /// Build will be called once, in the future Builder will be redrawn
  /// depending on the change in the state of the form [FormProvider.stateOf]
  /// or field [FormProvider.fieldsOf].
  @override
  Widget build(BuildContext context) {
    final field = _getProxyField(context);

    return Builder(builder: (context) {
      final formState = FormProvider.stateOf(context);
      FormProvider.fieldsOf(context, {name});

      return builder(context, field, formState);
    });
  }
}
