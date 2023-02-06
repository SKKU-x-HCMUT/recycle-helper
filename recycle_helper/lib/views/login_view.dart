import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:recycle_helper/constants.dart';
import 'package:recycle_helper/session.dart';

import 'package:recycle_helper/views/register_view.dart';
import 'package:recycle_helper/views/main_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email, _password;

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Session session = Session();
      try {
        final response = await session.post(
          "$addr/api/login",
          json.encode({
            'email': _email,
            'password': _password,
          }),
        );

        if (response.statusCode == 200) {
          session.updateCookie(response);
          final decodedResponse = json.decode(response.body);
          session.localId = decodedResponse['localId'];

          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logged in account: \"$_email\"")),
            );

            // go to Mainpage without back
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainView(session: session)),
            );
          }
        } else {
          throw Exception('Login failed');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //email
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null; //null means valid
                },
                onSaved: (value) => _email = value,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              //password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              //submit button
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logging in...")),
                  );
                  _login(context);
                },
                child: const Text('Login'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
