import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycle_helper/screens/auth.dart';
import 'package:recycle_helper/session.dart';
import 'package:recycle_helper/constraints.dart';

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
      response =
          await widget.session.get('$addr/api/user/${widget.session.localId}');
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
    final response = await widget.session.get("$addr/api/logout");
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
        if (snapshot.hasData) {
          List<Widget> infoTiles = [];
          String rawData = snapshot.data!.body;
          Map decodedData = json.decode(rawData);

          //get email
          infoTiles.add(Card(
            child: ListTile(
              leading: const Text("Email Address"),
              title: Text(decodedData["email"]),
            ),
          ));

          //get points
          infoTiles.add(Card(
            child: ListTile(
              leading: const Text("Points"),
              title: Text(decodedData["points"].toString()),
            ),
          ));

          infoTiles.add(const ListTile(title: Text("Vouchers")));

          //TODO: mockup voucher yet. need to change to real data
          infoTiles.add(Card(
            child: ListTile(
              title: const Text("Voucher 1"),
              subtitle: Text("desciption of Voucher 1"),
            ),
          ));

          return Column(
            children: infoTiles +
                [
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
        }

        return const Text("Loading user info...");
      },
    );
  }
}
