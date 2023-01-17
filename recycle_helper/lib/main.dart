import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Recycle Helper",
      home: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: LoginWidget(),
        ),
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Form(
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
            onPressed: _login,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // calling login API goes here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in account: \"$_email\"")),
      ); //Show toast when successfully logged in
    }
  }
}
