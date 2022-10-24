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
  /// Storing the created subscribers.
  final _fieldsObservers = HashMap<String, VoidCallback>();

  /// We save the fields for subscribers who need to be notified.
  ///
  /// [SFormProvider.fieldsOf], [SFormProvider.valuesOf].
  final _dirty = <String, bool>{};

  _InheritedFieldsElement(_FormFieldsProvider widget) : super(widget) {
    _controller.fieldsSubject.addListener(_updateFields);
  }

  @override
  _FormFieldsProvider get widget => super.widget as _FormFieldsProvider;

  SFormController get _controller => widget.controller;

  /// 1) Subscribe to add new fields [SFormFieldSubject].
  void _updateFields() {
    final fields = _controller.fieldsSubject;

    for (final name in fields.value.keys) {
      if (_fieldsObservers.containsKey(name)) continue;

      final field = fields.value[name]!;
      _dirty[name] = false;
      final notify = _fieldsObservers[name] = () => _notify(name);
      field.addListener(notify);
    }
  }

  /// 2) We add to subscribers that they want to listen to certain
  /// fields or all.
  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final fieldsSubscribe = getDependencies(dependent) as Set<String>?;
    if (fieldsSubscribe != null && fieldsSubscribe.isEmpty) return;

    if (aspect == null) {
      setDependencies(dependent, HashSet<String>());
    } else {
      final deps = (fieldsSubscribe ?? HashSet<String>())
        ..addAll(aspect as Set<String>);
      setDependencies(dependent, deps);
    }
  }

  /// 3) The field has been updated, you need to call [build]
  /// to notify subscribers.
  void _notify(String name) {
    _dirty[name] = true;
    markNeedsBuild();
  }

  /// 4) We check for dirty fields, if there are any, notify
  /// subscribers [notifyClients].
  @override
  Widget build() {
    if (_dirty.values.any((isDirty) => isDirty)) {
      notifyClients(widget);
    }

    return super.build();
  }

  /// 5) We call method [notifyDependent] for each subscriber, after
  /// that we will assume that all subscribers are notified
  /// about dirty fields.
  @override
  void notifyClients(InheritedWidget oldWidget) {
    super.notifyClients(oldWidget);
    _dirty.forEach((key, value) => _dirty[key] = false);
  }

  /// 6) We check that the subscriber really needs to know about the change.
  /// Either he is subscribed to all fields (if they are not specified),
  /// or he is subscribed to specific ones and then we will check
  /// through method [_maybeUpdate].
  ///
  /// [InheritedElement.notifyDependent] will call
  /// method [Element.markNeedsBuild].
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

  /// 6.1) We check that the signed field is dirty and it exists.
  bool _maybeUpdate(String name) {
    final isDirty = _dirty[name] ?? false;
    final field = _controller.fieldsSubject.getField(name);

    return isDirty && field != null;
  }

  /// Destroying all subscriptions.
  @override
  void unmount() {
    for (final field in _fieldsObservers.entries) {
      final fields = widget.controller.fieldsSubject.value;
      fields[field.key]?.removeListener(field.value);
    }

    _controller.fieldsSubject.removeListener(_updateFields);

    super.unmount();
  }
}
