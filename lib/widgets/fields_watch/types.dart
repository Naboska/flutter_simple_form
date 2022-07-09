part of 'fields_watch.dart';

/// The fields watch builder will return actual [SFormFields].
typedef SFieldsWatchBuilder<T> = Widget Function(
  BuildContext context,
  SFormFields values,
);
