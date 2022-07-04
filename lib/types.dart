import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_simple_form/flutter_simple_form.dart';

/// Registered fields in the [SFormController].
typedef SFormFieldsSubjects = Map<String, SFormFieldSubject>;

/// State of fields [SFormFieldSubject].
typedef SFormFields = Map<String, SFormFieldState>;

/// Current errors in the fields [SFormFieldState.errorMessage].
typedef SFormErrorValues = Map<String, String>;

/// Current values in the fields [SFormFieldState.value].
typedef SFormValues = Map<String, dynamic>;

/// Function for validating fields, see [SFormValidationResolver.validate].
typedef SFormValidationHandler = Future<SFormErrorValues> Function(
  SFormValues values,
);

/// Function for create [SFormController].
typedef SFormControllerCreate = SFormController Function(BuildContext context);
