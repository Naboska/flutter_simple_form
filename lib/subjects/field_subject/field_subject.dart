import '../base_subject.dart';

part 'field_state.dart';

class SFormFieldSubject<T> extends BaseSubject<SFormFieldState<T>> {
  /// Initial value for the field value.
  ///
  /// It is also set when calling the [reset] method.
  final T? initialValue;

  SFormFieldSubject({
    this.initialValue,
  }) : super(SFormFieldState<T>(value: initialValue));

  /// An internal method for monitoring the new state.
  ///
  /// Sets [SFormFieldState.isDirty] to `true`.
  @override
  set value(SFormFieldState<T> newState) {
    if (!newState.isDirty) {
      newState = newState.copyWith(
        isDirty: true,
        value: newState.value,
        errorMessage: newState.errorMessage,
      );
    }

    super.value = newState;
  }

  /// Safely changing the field value.
  ///
  /// Sets [SFormFieldState.value] to [newValue], if they are not identical.
  void setValue(T? newValue) {
    if (value.value == newValue) return;

    value = value.copyWith(
      value: newValue,
      errorMessage: value.errorMessage,
    );
  }

  /// Visiting the field. Must be called manually.
  ///
  /// Sets [SFormFieldState.isTouched] to `true`, if it is not `true`.
  void touch() {
    if (value.isTouched) return;

    value = value.copyWith(
      isTouched: true,
      value: value.value,
      errorMessage: value.errorMessage,
    );
  }

  /// Safely changing the error message.
  ///
  /// Sets [SFormFieldState.errorMessage] to [message], if they are not
  /// identical.
  void setError(String? message) {
    if (value.errorMessage == message) return;

    value = value.copyWith(
      value: value.value,
      errorMessage: message,
    );
  }

  /// Resets the state([SFormFieldState]) to the initial one.
  @override
  void reset([SFormFieldState<T>? resetValue]) {
    resetValue = resetValue ?? SFormFieldState<T>(value: initialValue);

    super.reset(resetValue);
  }
}
