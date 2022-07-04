part of 'field_controller.dart';

/// The field builder will return the current state of the form and
/// field subject by name [SFieldController.name].
typedef TFieldControllerBuilder<T> = Widget Function(
  BuildContext context,
  SFieldProxy<T> field,
  SFormState formState,
);
