import 'package:flutter/material.dart';
import 'package:recycle_helper/authentication.dart';
import 'package:recycle_helper/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //login_state = false

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Recycle Helper",
      home: //check login state and go to loginpage or mainpage
          //if(login_state == false)
          MainPage(),
    );
  }
}
