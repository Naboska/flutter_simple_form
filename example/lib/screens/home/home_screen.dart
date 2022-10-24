import 'package:flutter/material.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SFormController _formController;
  SFormValues? _result;

  @override
  void initState() {
    super.initState();

    _formController = SFormController();
  }

  Future<void> _onFormSubmit(SFormValues values) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _result = values);
    _formController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SFormProvider(
            controller: _formController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const STextField(
                  name: 'username',
                  decoration: InputDecoration(label: Text('username')),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () =>
                      _formController.setValue('username', value: 'test'),
                  child: const Text('set username'),
                ),
                const SizedBox(height: 14),
                Builder(
                  builder: (BuildContext context) {
                    final form = SFormProvider.stateOf(context);
                    final isDisabled = form.isSubmitting || !form.isDirty;

                    return ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () => _formController.handleSubmit(_onFormSubmit),
                      child: Text(
                        form.isSubmitting ? 'Submitting...' : 'Submit',
                      ),
                    );
                  },
                ),
                if (_result != null) ...<Widget>[
                  const SizedBox(height: 14),
                  Text('submit result: $_result'),
                ],
                const SizedBox(height: 14),
                const FormInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
