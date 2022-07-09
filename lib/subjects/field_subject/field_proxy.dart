part of 'field_subject.dart';

/// Necessary for typing [SFormFieldSubject].
class SFieldProxy<T> {
  /// Field with dynamic [SFormFieldState].
  final SFormFieldSubject _field;

  const SFieldProxy(this._field);

  /// Proxy for [SFormFieldSubject.state].
  SFormFieldState<T> get state {
    final state = _field.state;

    return SFormFieldState<T>(
      value: state.value,
      errorMessage: state.errorMessage,
      isDirty: state.isDirty,
      isTouched: state.isTouched,
    );
  }

  /// Proxy for [SFormFieldSubject.setValue].
  void setValue(T? newValue) => _field.setValue(newValue);

  /// Proxy for [SFormFieldSubject.touch].
  void touch() => _field.touch();

  /// Proxy for [SFormFieldSubject.setError].
  void setError(String? message) => _field.setError(message);

  /// Proxy for [SFormFieldSubject.reset].
  void reset() => _field.reset();
}
