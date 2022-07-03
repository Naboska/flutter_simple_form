part of 'form_provider.dart';

class SFormController {
  final stateSubject = SFormStateSubject();
  final fieldsSubject = SFormFieldsSubject();
  final SFormValues? initialValues;
  late final SFormValidationResolver? validationResolver;

  SFormState get state => stateSubject.value;

  SFormFields get fields =>
      fieldsSubject.value.map((name, field) => MapEntry(name, field.value));

  SFormValues get values =>
      fields.map((name, state) => MapEntry(name, state.value));

  SFormController({
    this.initialValues,
    SFormValidationResolver? validationResolver,
    SFormValidationHandler? validate,
  }) : assert(
          (validationResolver != null && validate == null) ||
              (validate != null && validationResolver == null),
          'it is necessary to initialize either validationResolver or validate',
        ) {
    if (validationResolver != null) {
      this.validationResolver = validationResolver;
    } else if (validate != null) {
      this.validationResolver = SFormValidationResolver(
        validator: null,
        validate: validate,
      );
    }

    initialValues?.forEach((key, _) => register(key));
  }

  void dispose() {
    for (final field in fieldsSubject.value.values) {
      field.close();
    }
    fieldsSubject.close();
    stateSubject.close();
  }

  SFormFieldSubject register(String name) {
    SFormFieldSubject? field = fieldsSubject.getField(name);
    if (field != null) return field;

    field = fieldsSubject.createField(name, initialValues?[name]);

    fieldsSubject.addListener(() {
      final field = fieldsSubject.getField(name);
      if (field == null || !field.isDirty) return;

      final state = field.value;
      final prevState = field.prevValue;
      final bool isValueChanged = state.value != prevState.value;
      final bool isTouched = state.isTouched != prevState.isTouched;

      stateSubject.handleDirty();

      if (isValueChanged || isTouched) triggerValidate();
    });

    Future.microtask(fieldsSubject.notifyListeners);

    return field;
  }

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

  void setValue(
    String name, {
    required dynamic value,
    bool shouldTouch = false,
  }) {
    final field = register(name);

    field.setValue(value);
    if (shouldTouch) field.touch();
  }

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

  void setError(String name, {String? message}) {
    final field = register(name);

    field.setError(message);
  }

  void touchField(String name) {
    final field = fieldsSubject.getField(name);
    if (field == null) return;

    field.touch();
  }

  void resetField(String name, [dynamic initialValue]) {
    final field = fieldsSubject.getField(name);
    if (field == null) return;

    field.reset(initialValue);
  }

  void reset({SFormValues? values}) {
    final fields = fieldsSubject.value;

    for (final name in fields.keys) {
      resetField(name, values?[name]);
    }

    stateSubject.reset();
  }
}
