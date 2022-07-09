part of 'form_watch.dart';

/// The form watch builder will return actual [SFormController].
typedef SFormWatchBuilder<T> = Widget Function(
  BuildContext context,
  SFormController form,
);
