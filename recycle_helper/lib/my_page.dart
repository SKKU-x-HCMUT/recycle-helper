import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycle_helper/auth_page.dart';
import 'package:recycle_helper/session.dart';

const String addr = "172.30.1.82:5000";

class MyPage extends StatefulWidget {
  final Session session;
  const MyPage({Key? key, required this.session}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<http.Response?> _getUserInfo() async {
    final http.Response response;
    try {
      response = await widget.session
          .get('http://$addr/api/user/${widget.session.localId}');
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('_getUserInfo() failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _logout(BuildContext context) async {
    final response = await widget.session.get("http://$addr/api/logout");
    final decodedResponse = json.decode(response.body);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(decodedResponse['message'])),
      );

      // go to Loginpage without back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response?>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        String info = "Loading user info...";
        if (snapshot.hasData) {
          info = snapshot.data!.body;
        }
        return Column(
          children: [
            Text(info),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
