import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext, VoidCallback;
import 'package:flutter_simple_form/flutter_simple_form.dart';

/// Signature of callbacks [SWatchController] for subscribers.
typedef SWatchListener = void Function(SFormValues values);

/// Notifies about field changes.
///
/// ### Example
///
/// ```dart
/// class NameOfState extends State<StatefulWidget> {
///   late final SWatchController _watchController;
///
///   @override
///   void initState() {
///     super.initState();
///
///     _watchController = SWatchController(context)
///       ..watch({'name'}, listener)
///       ..watch({'name', 'name2'}, listener2)
///       ..watch({'name3', 'name2'}, listener3)
///       ..watchAll(listener4);
///   }
///
///   @override
///   void dispose() {
///     _watchController.dispose();
///
///     super.dispose();
///   }
/// }
/// ```
class SWatchController {
  late final SFormController _controller;
  final _watch = <String, ObserverList<SWatchListener>>{};
  final _all = ObserverList<SWatchListener>();
  final _watchers = <String, VoidCallback>{};

  bool _isDispose = false;

  /// Creates [SWatchController] from [BuildContext].
  SWatchController(BuildContext context) {
    _controller = SFormProvider.of(context);
    _controller.fieldsSubject.addListener(_updateWatchers);
    _updateWatchers();
  }

  /// Creates [SWatchController] from [SFormController].
  SWatchController.from(this._controller) {
    _controller.fieldsSubject.addListener(_updateWatchers);
    _updateWatchers();
  }

  /// Listens to one or more fields.
  void watch(Set<String> fields, SWatchListener listener) {
    assert(!_isDispose, 'You can`t subscribe after call dispose');
    assert(fields.isNotEmpty, 'You must select at least one field');

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
    _isDispose = true;
    _controller.fieldsSubject.removeListener(_updateWatchers);
    _watchers.forEach(_unsubscribeField);
  }

  /// Internal method.
  ///
  /// Notifies subscribers about field changes.
  void _updateWatchers() {
    final fields = _controller.fieldsSubject.value;

    for (final field in fields.entries) {
      if (_watchers.keys.contains(field.key)) continue;

      field.value.addListener(
        _watchers[field.key] = () => _updateField(field.key),
      );

      _updateField(field.key);
    }
  }

  /// Internal method.
  ///
  /// Notifies the listeners of the field about the change.
  void _updateField(String name) {
    final field = _controller.fieldsSubject.getField(name)!;
    if (field.state.value == field.prevValue.value) return;

    _all.forEach(_notify);
    _watch[name]?.forEach(_notify);
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
