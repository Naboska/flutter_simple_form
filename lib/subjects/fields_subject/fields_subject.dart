import 'package:flutter_simple_form/types.dart';

import '../subjects.dart';

/// Required for tracking new fields in the form [SFormFieldSubject].
class SFormFieldsSubject extends BaseSubject<SFormFieldsSubjects> {
  SFormFieldsSubject() : super(<String, SFormFieldSubject>{});

  /// Creates a new field in the form, but does not notify subscribers.
  ///
  /// If the field already exists, it will return its subject.
  SFormFieldSubject createField(String name, [dynamic initialValue]) {
    final field = getField(name);

    if (field != null) return field;

    return (value[name] = SFormFieldSubject(initialValue));
  }

  /// Checks for the presence of a field in the form.
  SFormFieldSubject? getField(String name) => value[name];
}
