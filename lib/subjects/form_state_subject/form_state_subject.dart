import '../base_subject.dart';

part 'form_state.dart';

class SFormStateSubject extends BaseSubject<SFormState> {
  static const SFormState _initialValue = SFormState();

  SFormStateSubject() : super(_initialValue);

  /// Sets the dirty value of the form before updating.
  @override
  set value(SFormState newValue) {
    if (!newValue.isDirty) {
      newValue = newValue.copyWith(isDirty: true);
    }

    super.value = newValue;
  }

  /// Sets the form to a dirty state.
  ///
  /// Sets the value of [SFormState.isDirty] to `true`.
  ///
  /// The method will update the state once.
  void handleDirty() {
    if (value.isDirty) return;

    value = value.copyWith(isDirty: true);
  }

  /// Sets the form to the state of sending values.
  ///
  /// Sets the value of [SFormState.isSubmitting] to `true`.
  ///
  /// Increases the value of [SFormState.submitCount] by `1`.
  ///
  /// The method is called only if the value of [SFormState.isSubmitting]
  /// is `false`.
  void startSubmitting() {
    if (value.isSubmitting) return;

    value = value.copyWith(
      isSubmitting: true,
      submitCount: value.submitCount + 1,
    );
  }

  /// Puts the form in the state of stopping sending values.
  ///
  /// Sets the value of [SFormState.isSubmitting] to false.
  ///
  /// Increases the value of [SFormState.submitCount] by `1`.
  ///
  /// The method is called only if the value of [SFormState.isSubmitting]
  /// is `true`.
  void stopSubmitting() {
    if (!value.isSubmitting) return;

    value = value.copyWith(isSubmitted: true, isSubmitting: false);
  }

  /// Allows you to manage the validity of the form.
  ///
  /// Sets the value of [SFormState.isValid] to [isFormValid].
  void setValid(bool isFormValid) {
    if (value.isValid == isFormValid) return;

    value = value.copyWith(isValid: isFormValid);
  }

  /// Resets the state([SFormState]) of the form to the initial one.
  @override
  void reset([SFormState? resetValue]) {
    super.reset(resetValue ?? _initialValue);
  }
}
