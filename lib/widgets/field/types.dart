part of 'field.dart';

/// The field builder will return the current state of the form and
/// field subject by name [SField.name].
typedef SFieldBuilder<T> = Widget Function(
  BuildContext context,
  SFieldProxy<T> field,
  SFormState formState,
);
