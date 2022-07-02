import 'base_subject.dart';

class SFormStateSubject extends BaseSubject<SFormState> {
  static const SFormState _initialValue = SFormState();

  SFormStateSubject() : super(_initialValue);

  /// Current state of the form.
  @override
  SFormState get value => super.value!;

  /// Previous state of the form.
  @override
  SFormState get prevValue => super.prevValue!;

  /// Sets the dirty value of the form before updating.
  @override
  set value(SFormState? newValue) {
    newValue = newValue ?? _initialValue;

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

class SFormState {
  /// If changes were made to the form, the value will become `true`.
  ///
  /// Default: `false`
  ///
  /// See also:
  ///
  /// Method [SFormStateSubject.reset] resets the value to the default.
  final bool isDirty;

  /// If the form is currently being submitted, the value will become `true`.
  ///
  /// Default: `false`
  ///
  /// See also:
  ///
  /// Method [SFormStateSubject.startSubmitting] sets the current value
  /// to `true`.
  ///
  /// Methods ([SFormStateSubject.reset], [SFormStateSubject.stopSubmitting])
  /// resets the value to the default.
  final bool isSubmitting;

  /// If the form has been submitted at least once, the value will
  /// become `true`.
  ///
  /// Default: `false`
  ///
  /// See also:
  ///
  /// Method [SFormStateSubject.startSubmitting] sets the current value
  /// to `true`.
  ///
  /// Method [SFormStateSubject.reset] resets the value to the default.
  final bool isSubmitted;

  /// If there are no errors in the form, the value will become `true`.
  ///
  /// Default: `true`
  ///
  /// See also:
  ///
  /// Method [SFormStateSubject.setValid] sets the current value
  /// to `true` or `false`.
  ///
  /// Method [SFormStateSubject.reset] resets the value to the default.
  final bool isValid;

  /// Number of times the form was submitted.
  ///
  /// Default: `0`
  ///
  /// See also:
  ///
  /// Method [SFormStateSubject.startSubmitting] increases the value
  /// by `1`.
  ///
  /// Method [SFormStateSubject.reset] resets the value to the default.
  final int submitCount;

  const SFormState({
    this.isDirty = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.isValid = true,
    this.submitCount = 0,
  });

  SFormState copyWith({
    bool? isDirty,
    bool? isSubmitting,
    bool? isSubmitted,
    bool? isValid,
    int? submitCount,
  }) {
    return SFormState(
      isDirty: isDirty ?? this.isDirty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isValid: isValid ?? this.isValid,
      submitCount: submitCount ?? this.submitCount,
    );
  }

  @override
  String toString() {
    return '''
---------------------------------
SFormState:
-isDirty: $isDirty
-isValid: $isValid  
-isSubmitting: $isSubmitting
-isSubmitted: $isSubmitted
-submitCount: $submitCount
---------------------------------
    ''';
  }
}
