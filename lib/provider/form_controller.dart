part of 'provider.dart';

class SFormController {
  final _stateSubject = SFormStateSubject();

  SFormState get state => _stateSubject.value;

  void dispose() {
    _stateSubject.close();
  }
}
