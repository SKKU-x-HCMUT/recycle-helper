import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<String> _getUserInfo() async {
    final url = Uri.parse('http://localhost:5000/api/users');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({}),
    );
    return response.body;
  }

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('http://localhost:5000/api/logout');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({}),
    );

    // Show toast
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );

      // go to Loginpage without back
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        return Column(
          children: [
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
