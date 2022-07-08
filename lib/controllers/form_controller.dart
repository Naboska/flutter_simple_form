import 'package:flutter_simple_form/flutter_simple_form.dart';

/// Controller for the form.
///
/// Used to safely change the state of the form [SFormController.state] and
/// the state of the fields [SFormController.fields].
class SFormController {
  /// Form state [SFormState] management.
  ///
  /// Often, you don't need to address the state directly.
  ///
  /// This is useful if you want to implement your methods on top
  /// of the existing ones in the controller.
  final stateSubject = SFormStateSubject();

  /// Managing current fields.
  ///
  /// Contains state of [Map] ([String]=[SFormFieldSubject]).
  ///
  /// It is forbidden to change the current value manually,
  /// this can lead to a large number of errors. Create a new field exclusively
  /// using the [register] method. Delete using the [reset] method.
  ///
  /// Necessary for manual control of [SFormFieldSubject].
  final fieldsSubject = SFormFieldsSubject();

  /// Initial values for fields.
  ///
  /// Each of the values will immediately [register] a new field.
  final SFormValues? initialValues;

  /// {@macro flutter_simple_form.validation_resolver}
  ///
  /// It has 2 creation options.
  ///
  /// 1) `validate` function when creating it, the controller
  /// will create a wrapper over this function.
  ///
  /// 2) `validationResolver` see in [SFormValidationResolver].
  late final SFormValidationResolver? validationResolver;

  /// Gives an understanding that the controller is destroyed.
  bool isDispose = false;

  /// Getter for the state of the form [SFormState].
  SFormState get state => stateSubject.value;

  /// Getter for getting the state of fields [SFormFields].
  SFormFields get fields =>
      fieldsSubject.value.map((name, field) => MapEntry(name, field.value));

  /// Getter for getting the values of fields [SFormValues].
  SFormValues get values => fieldsSubject.value
      .map((name, state) => MapEntry(name, state.value.value));

  SFormController({
    this.initialValues,
    SFormValidationResolver? validationResolver,
    SFormValidationHandler? validate,
  }) : assert(
          (validationResolver != null && validate == null) ||
              (validate != null && validationResolver == null) ||
              (validate == null && validationResolver == null),
          'it is necessary to initialize either validationResolver or validate',
        ) {
    // Initialize [SFormValidationResolver].
    if (validationResolver != null) {
      this.validationResolver = validationResolver;
    } else if (validate != null) {
      this.validationResolver = SFormValidationResolver(
        validator: null,
        validate: validate,
      );
    } else {
      this.validationResolver = null;
    }
    // End [SFormValidationResolver].

    initialValues?.forEach((key, _) => register(key));
  }

  /// Destroys all subscriptions to the subject's, and closes access
  /// to the controller's methods.
  void dispose() {
    if (isDispose) return;

    for (final field in fieldsSubject.value.values) {
      field.close();
    }

    fieldsSubject.close();
    stateSubject.close();

    isDispose = true;
  }

  /// Registers a new field if it does not exist.
  ///
  /// Creates a subscription to change the field [SFormFieldState] to change
  /// the state of the form [SFormState].
  SFormFieldSubject register(String name) {
    assert(!isDispose, 'The form is destroyed, you can`t add a new field');

    SFormFieldSubject? field = fieldsSubject.getField(name);
    if (field != null) return field;

    field = fieldsSubject.createField(name, initialValues?[name]);

    field.addListener(() {
      final field = fieldsSubject.getField(name);
      if (field == null || !field.isDirty) return;

      final bool isEqual = field.value.isEqual(field.prevValue);
      if (!isEqual) triggerValidate();
      stateSubject.handleDirty();
    });

    Future.microtask(fieldsSubject.notifyListeners);

    return field;
  }

  /// Checks the validity of the form.
  ///
  /// If no [validationResolver] is created, validation will always
  /// return `true`.
  Future<bool> triggerValidate([String? name]) async {
    final resolver = validationResolver;
    if (resolver == null) return true;

    final errors = await resolver.validate(values);
    final isValid = name == null ? errors.isEmpty : errors[name] == null;

    if (name == null) {
      for (String fieldName in fieldsSubject.value.keys) {
        setError(fieldName, message: errors[fieldName]);
      }
    } else {
      setError(name, message: errors[name]);
    }

    stateSubject.setValid(errors.isEmpty);

    return isValid;
  }

  /// Sets the value for the field.
  ///
  /// If there was no field before, the method will register it.
  ///
  /// See also:
  ///
  /// Set value - [SFormFieldSubject.setValue].
  ///
  /// Touch - [SFormFieldSubject.touch].
  void setValue(
    String name, {
    required dynamic value,
    bool shouldTouch = false,
  }) {
    final field = register(name);

    field.setValue(value);
    if (shouldTouch) field.touch();
  }

  /// Massively sets the value for fields.
  ///
  /// See [setValue].
  void setValues(
    SFormValues values, {
    bool shouldTouch = false,
  }) {
    for (final field in values.entries) {
      setValue(
        field.key,
        value: field.value,
        shouldTouch: shouldTouch,
      );
    }
  }

  /// Sets an error for the field.
  ///
  /// If there was no field before, the method will register it.
  ///
  /// See [SFormFieldSubject.setError].
  void setError(String name, {String? message}) {
    final field = register(name);

    field.setError(message);
  }

  /// Sets [SFormFieldState.isTouched] for the field, if it exists.
  ///
  /// See [SFormFieldSubject.touch].
  void touchField(String name) {
    final field = fieldsSubject.getField(name);
    if (field == null) return;

    field.touch();
  }

  /// Resets the state of the field to [initialValues] or [initialValue],
  /// if field exists.
  ///
  /// See [SFormFieldSubject.reset].
  void resetField(String name, [dynamic initialValue]) {
    final field = fieldsSubject.getField(name);
    if (field == null) return;

    field.reset(initialValue);
  }

  /// Resets fields and state of the form to initial.
  ///
  /// See also:
  ///
  /// Field reset: [resetField].
  ///
  /// Form state reset: [SFormStateSubject.reset].
  void reset({SFormValues? values}) {
    final fields = fieldsSubject.value;

    for (final name in fields.keys) {
      resetField(name, values?[name]);
    }

    stateSubject.reset();
  }
}
