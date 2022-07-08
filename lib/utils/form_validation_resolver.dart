import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_simple_form/flutter_simple_form.dart';

/// {@template flutter_simple_form.validation_resolver}
/// Validation resolver for your form. When creating your resolver, you
/// can get it below the [BuildContext] and work with it
/// (for example: subscribe).
/// {@endtemplate}
class SFormValidationResolver<T> {
  /// Your validation object.
  ///
  /// You can get it through [SFormController.validationResolver.validator]
  final T validator;

  /// Function for form validation.
  ///
  /// The [SFormController] will transmit the current values of the form
  /// to the input, the function should return [Future] => [SFormErrorValues].
  final SFormValidationHandler validate;

  const SFormValidationResolver({
    required this.validator,
    required this.validate,
  });
}
