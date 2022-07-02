import '../base_subject.dart';

part 'form_field_state.dart';

class SFormFieldSubject<T> extends BaseSubject<SFormFieldState<T>> {
  final T? initialState;

  SFormFieldSubject({
    this.initialState,
  }) : super(SFormFieldState<T>(state: initialState));

  @override
  set value(SFormFieldState<T> newValue) {
    if (!newValue.isDirty) {
      newValue = newValue.copyWith(
        isDirty: true,
        state: newValue.state,
        errorMessage: newValue.errorMessage,
      );
    }

    super.value = newValue;
  }

  void setState(T? newState) {
    if (value.state == newState) return;

    value = value.copyWith(
      state: newState,
      errorMessage: value.errorMessage,
    );
  }

  void touch() {
    if (value.isTouched) return;

    value = value.copyWith(
      isTouched: true,
      state: value.state,
      errorMessage: value.errorMessage,
    );
  }

  void setError(String? message) {
    if (value.errorMessage == message) return;

    value = value.copyWith(
      state: value.state,
      errorMessage: message,
    );
  }

  @override
  void reset([SFormFieldState<T>? resetValue]) {
    resetValue = resetValue ?? SFormFieldState<T>(state: initialState);

    super.reset(resetValue);
  }
}
