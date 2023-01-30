import 'package:flutter/material.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

extension XBuildContext on BuildContext {
  /// [SFormProvider.of].
  SFormController get form => SFormProvider.of(this);

  /// [SFormProvider.stateOf].
  ///
  /// For readOnly use [form.state].
  SFormState get formState => SFormProvider.stateOf(this);

  /// [SFormProvider.valuesOf].
  SFormValues formValues([Set<String>? fields]) =>
      SFormProvider.valuesOf(this, fields);

  /// [SFormProvider.fieldsOf].
  SFormFields formFields([Set<String>? fields]) =>
      SFormProvider.fieldsOf(this, fields);
}
