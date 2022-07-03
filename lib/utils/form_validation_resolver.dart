import 'package:flutter_simple_form/types.dart';

class SFormValidationResolver<T> {
  final T validator;
  final SFormValidationHandler validate;

  const SFormValidationResolver({
    required this.validator,
    required this.validate,
  });
}
