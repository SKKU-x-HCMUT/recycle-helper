import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:recycle_helper/constants.dart';
import 'package:recycle_helper/session.dart';

import 'package:recycle_helper/views/login_view.dart';

class UserPage extends StatefulWidget {
  final Session session;
  const UserPage({Key? key, required this.session}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<Map?> _getUserInfo() async {
    final http.Response response;
    try {
      response =
          await widget.session.get('$addr/api/user/${widget.session.localId}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
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
    return FutureBuilder<Map?>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading user info...");
        }
        if (snapshot.data == null) {
          return const Text("Loading user info failed.");
        }

        Map userInfo = snapshot.data!;

        List<Widget> userInfoTiles = [
          const ListTile(title: Text("Informations")),
        ];

        //get email
        userInfoTiles.add(Card(
          child: ListTile(
            leading: const Text("Email Address"),
            title: Text(userInfo["email"]),
          ),
        ));

        //get points
        userInfoTiles.add(Card(
          child: ListTile(
            leading: const Text("Points"),
            title: Text(userInfo["points"].toString()),
          ),
        ));

        Map? vouchers = userInfo["vouchers"];

        List<Widget> userVoucherTiles = [
          const ListTile(title: Text("Vouchers")),
        ];

        if (vouchers != null) {
          vouchers.forEach(
            (key, value) {
              final quantity = value["quantity"];

              // repeat as quantity
              for (int i = 0; i < quantity; i++) {
                userVoucherTiles.add(Card(
                  child: ListTile(
                    title: Text(value["storeName"]),
                    //subtitle: Text("desciption of Voucher"),
                  ),
                ));
              }
            },
          );
        } else {
          userVoucherTiles.add(const Card(
              child: ListTile(title: Text("No Vouchers Available."))));
        }

        List<Widget> children = userInfoTiles +
            userVoucherTiles +
            [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _logout(context),
                child: const Text('Logout'),
              )
            ];

        return Column(
          children: children,
        );
      },
    );
  }
}
