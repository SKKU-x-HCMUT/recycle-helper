import 'package:flutter/material.dart';

import 'package:recycle_helper/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.lightGreen,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      title: "Recycle Helper",
      home: const LoginPage(),
    );
  }
}
