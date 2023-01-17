import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              //email
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (input) => _email = input,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              //password
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (input) => _password = input,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              //submit button
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // calling login API goes here
    }
  }
}
