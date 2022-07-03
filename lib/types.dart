import 'package:flutter_simple_form/subjects/subjects.dart';

typedef SFormFieldsSubjects = Map<String, SFormFieldSubject>;
typedef SFormFields = Map<String, SFormFieldState>;

typedef SFormErrorValues = Map<String, String>;
typedef SFormValidationHandler = Future<SFormErrorValues> Function(
  SFormValues values,
);

typedef SFormValues = Map<String, dynamic>;
