import 'package:flutter/foundation.dart'
    show ObserverList, VoidCallback, ValueListenable, protected;

/// Allows you to create subscriptions to change the value.
abstract class BaseSubject<T> implements ValueListenable<T> {
  final ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();

  BaseSubject(this._value) : _prevValue = _value;

  /// The current value of the subject.
  ///
  /// Setting a new value puts the old value in [prevValue] and makes
  /// the subject dirty [isDirty].
  @override
  T get value => _value;
  T _value;

  /// Listeners will receive an alert even if the value has not been changed.
  @protected
  set value(T newValue) {
    _prevValue = _value;
    _value = newValue;
    _isDirty = true;

    notifyListeners();
  }

  /// The previous value of the subject.
  T get prevValue => _prevValue;
  T _prevValue;

  /// If the subject has been modified, the value will be set to `true`.
  bool get isDirty => _isDirty;
  bool _isDirty = false;

  /// if the subject was closed, the value will be `true`.
  bool isClose = false;

  /// Close the current subject.
  void close() {
    if (isClose) return;

    isClose = true;
    _listeners.clear();
  }

  /// Resets the state of the subject to its original state.
  ///
  /// If a [resetValue] is specified, the method will set them as default
  /// values in [value] and [prevValue].
  void reset(T resetValue) {
    _isDirty = false;
    _prevValue = resetValue;
    _value = resetValue;

    notifyListeners();
  }

  /// Calls the listener every time the value of the subject changes.
  ///
  /// Listeners can be removed with [removeListener].
  @override
  void addListener(VoidCallback listener) {
    if (isClose) {
      throw AssertionError('Are you trying to subscribe to a dead subject');
    }

    _listeners.add(listener);
  }

  /// Stop calling the listener every time the value of the subject changes.
  ///
  /// Listeners can be added with [addListener].
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Notifies current listeners about the subject change.
  void notifyListeners() {
    if (_listeners.isEmpty) return;

    for (final VoidCallback listener in _listeners) {
      listener();
    }
  }
}
