import 'package:flutter/material.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

class FormInfo extends StatelessWidget {
  const FormInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SFormWatch(
      watchAll: true,
      builder: (_, form) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${form.state}'),
            for (final field in form.fields.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('field: ${field.key}'),
                  Text('${field.value}'),
                ],
              ),
          ],
        );
      },
    );
  }
}
