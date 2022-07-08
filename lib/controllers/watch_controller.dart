import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext, VoidCallback;
import 'package:flutter_simple_form/flutter_simple_form.dart';

/// Signature of callbacks [SWatchController] for subscribers.
typedef SWatchListener = void Function(SFormValues values);

/// Notifies about field changes.
class SWatchController {
  late final SFormController _controller;
  final _watch = <String, ObserverList<SWatchListener>>{};
  final _all = ObserverList<SWatchListener>();
  final _only = <String, VoidCallback>{};
  bool _isDispose = false;

  /// Creates [SWatchController] from [BuildContext].
  SWatchController(BuildContext context) {
    _controller = FormProvider.of(context);
    _controller.fieldsSubject.addListener(_updateWatchers);
  }

  /// Creates [SWatchController] from [SFormController].
  SWatchController.from(this._controller) {
    _controller.fieldsSubject.addListener(_updateWatchers);
  }

  /// Listens to one or more fields.
  void watch(Set<String> fields, SWatchListener listener) {
    assert(!_isDispose, 'You can`t subscribe after call dispose');

    for (final name in fields) {
      (_watch[name] ??= ObserverList<SWatchListener>()).add(listener);
    }
  }

  /// Listens to all fields.
  void watchAll(SWatchListener listener) {
    assert(!_isDispose, 'You can`t subscribe after call dispose');

    _all.add(listener);
  }

  /// Called when this [SWatchController] is removed permanently.
  void dispose() {
    final fields = _controller.fieldsSubject;

    _isDispose = true;
    fields.removeListener(_updateWatchers);
    _only.forEach(_unsubscribeField);
  }

  /// Internal method.
  ///
  /// Notifies subscribers about field changes.
  void _updateWatchers() {
    final fields = _controller.fieldsSubject.value;
    _all.forEach(_notify);
    fields.keys.forEach(_updateField);
  }

  /// Internal method.
  ///
  /// Notifies the listeners of the field about the change.
  ///
  /// If there are no subscribers or subscribers are created,
  /// the function is ignored.
  void _updateField(String name) {
    if (_watch[name] == null || _only[name] != null) return;

    final obs = (_only[name] = () => _watch[name]!.forEach(_notify))..call();
    _controller.fieldsSubject.value[name]!.addListener(obs);
  }

  /// Internal method.
  ///
  /// Passes the current values to the listener.
  void _notify(SWatchListener listener) {
    listener(_controller.values);
  }

  /// Internal method.
  ///
  /// Destroys the subscription if the field still exists.
  void _unsubscribeField(String name, VoidCallback listener) {
    final field = _controller.fieldsSubject.getField(name);
    field?.removeListener(listener);
  }
}
