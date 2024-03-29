part of 'field_subject.dart';

/// The field state model. Controlled via [SFormFieldSubject].
class SFormFieldState<T> {
  /// The current value for the field, can be null or [T].
  ///
  /// Default: [T] | `null`
  ///
  /// See also:
  ///
  /// Method [SFormFieldSubject.setValue] allows you to set a new value.
  ///
  /// Method [SFormFieldSubject.reset] resets the value to the default.
  final T? value;

  /// The error message that the field received after validation
  /// or after manual installation.
  ///
  /// Default: `null`
  ///
  /// See also:
  ///
  /// Method [SFormFieldSubject.setError] allows you to
  /// set the message manually.
  ///
  /// Method [SFormFieldSubject.reset] resets the value to the default.
  final String? errorMessage;

  /// [bool] alias for [errorMessage], `true` if [errorMessage] equal
  /// to `null`.
  final bool isValid;

  /// If changes were made to the field, the value will become `true`.
  ///
  /// Default: `false`
  ///
  /// See also:
  ///
  /// Method [SFormFieldSubject.reset] resets the value to the default.
  final bool isDirty;

  /// Shows whether the field was visited. It is set only manually,
  /// usually after the user has lost focus from the field.
  ///
  /// Default: `false`
  ///
  /// See also:
  ///
  /// Method [SFormFieldSubject.touch] manages this value.
  ///
  /// Method [SFormFieldSubject.reset] resets the value to the default.
  final bool isTouched;

  const SFormFieldState({
    this.value,
    this.errorMessage,
    this.isDirty = false,
    this.isTouched = false,
  }) : isValid = errorMessage == null;

  /// Another method for getting the value is needed for point
  /// typing of the [value].
  ///
  /// If the types don't match, the method returns an error.
  X getValue<X extends T>() => value as X;

  /// An internal method for copying the field state,
  /// you probably won't need it.
  SFormFieldState<T> copyWith({
    T? value,
    String? errorMessage,
    bool? isDirty,
    bool? isTouched,
  }) {
    return SFormFieldState(
      value: value,
      errorMessage: errorMessage,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
    );
  }

  bool isEqual(SFormFieldState? fieldState) {
    return errorMessage == fieldState?.errorMessage &&
        isEqualWithoutError(fieldState);
  }

  bool isEqualWithoutError(SFormFieldState? fieldState) {
    return value == fieldState?.value &&
        isDirty == fieldState?.isDirty &&
        isTouched == fieldState?.isTouched;
  }

  /// Displays information about the current state of the field.
  @override
  String toString() {
    return '''
---------------------------------
SFormFieldState<${value.runtimeType}>:
-value: $value
-errorMessage: $errorMessage  
-isDirty: $isDirty
-isTouched: $isTouched
---------------------------------
    ''';
  }
}
