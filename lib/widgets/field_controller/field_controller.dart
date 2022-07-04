import 'package:flutter/widgets.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

part 'types.dart';

class SFieldController<T> extends StatelessWidget {
  final String name;
  final TFieldControllerBuilder<T> builder;

  const SFieldController({
    Key? key,
    required this.name,
    required this.builder,
  }) : super(key: key);

  SFieldProxy<T> _getProxyField(BuildContext context) {
    final controller = FormProvider.of(context);
    final field = controller.register(name);

    return SFieldProxy<T>(field);
  }

  @override
  Widget build(BuildContext context) {
    final field = _getProxyField(context);
    print('saa');

    return Builder(builder: (context) {
      final formState = FormProvider.stateOf(context);
      FormProvider.fieldsOf(context, {name});

      return builder(context, field, formState);
    });
  }
}
