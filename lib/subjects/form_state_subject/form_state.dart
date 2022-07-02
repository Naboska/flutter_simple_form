part of 'form_state_subject.dart';

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
