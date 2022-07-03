part of 'form_provider.dart';

class _FormFieldsProvider extends InheritedWidget {
  final SFormController controller;

  const _FormFieldsProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_FormFieldsProvider oldWidget) => false;

  @override
  _InheritedFieldsElement createElement() => _InheritedFieldsElement(this);
}

class _InheritedFieldsElement extends InheritedElement {
  final _fieldsObservers = HashMap<String, VoidCallback>();
  final _dirty = <String, bool>{};

  _InheritedFieldsElement(_FormFieldsProvider widget) : super(widget) {
    widget.controller.fieldsSubject.addListener(_updateFields);
  }

  @override
  _FormFieldsProvider get widget => super.widget as _FormFieldsProvider;

  SFormController get controller => widget.controller;

  @override
  void notifyDependent(
    covariant _FormFieldsProvider oldWidget,
    Element dependent,
  ) {
    final aspects = getDependencies(dependent) as Set<String>?;
    if (aspects == null) return;

    if (aspects.isEmpty || aspects.any(_maybeUpdate)) {
      super.notifyDependent(oldWidget, dependent);
    }
  }

  @override
  void unmount() {
    for (final field in _fieldsObservers.entries) {
      final fields = widget.controller.fieldsSubject.value;
      fields[field.key]?.removeListener(field.value);
    }

    super.unmount();
  }

  bool _maybeUpdate(String name) {
    final isDirty = _dirty[name] ?? false;
    final field = controller.fieldsSubject.getField(name);

    return isDirty || field != null;
  }

  void _notify(String name) {
    _dirty[name] = true;
    notifyClients(widget);

    _dirty[name] = false;
  }

  void _updateFields() {
    final fields = controller.fieldsSubject;

    for (final name in fields.value.keys) {
      if (_fieldsObservers.containsKey(name)) continue;

      final field = fields.value[name]!;
      _dirty[name] = false;
      _prevValues[name] = field.value;
      final notify = _fieldsObservers[name] = () => _notify(name);
      field.addListener(notify);
    }
  }
}
