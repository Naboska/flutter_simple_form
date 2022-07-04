part of 'field_subject.dart';

/// Necessary for typing [SFormFieldSubject].
class SFieldProxy<T> {
  /// Field with dynamic [SFormFieldState];
  final SFormFieldSubject field;

  const SFieldProxy(this.field);

  /// Proxy for [SFormFieldSubject.state].
  SFormFieldState<T> get state {
    final state = field.state;

    return SFormFieldState<T>(
      value: state.value,
      errorMessage: state.errorMessage,
      isDirty: state.isDirty,
      isTouched: state.isTouched,
    );
  }

  /// Proxy for [SFormFieldSubject.setValue].
  void setValue(T? newValue) => field.setValue(newValue);

  /// Proxy for [SFormFieldSubject.touch].
  void touch() => field.touch();

  /// Proxy for [SFormFieldSubject.setError].
  void setError(String? message) => field.setError(message);

  /// Proxy for [SFormFieldSubject.reset].
  void reset() => field.reset();
}
