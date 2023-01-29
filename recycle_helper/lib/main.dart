import 'package:flutter/material.dart';
import 'package:recycle_helper/authentication.dart';
import 'package:recycle_helper/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Recycle Helper",
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage(),
        });
  }
}
