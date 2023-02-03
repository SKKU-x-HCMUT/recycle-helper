import 'package:flutter/material.dart';

import 'package:recycle_helper/screens/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Recycle Helper",
      home: LoginPage(),
    );
  }
}
