import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recycle_helper/session.dart';

const String addr = "172.30.1.82:5000";

class VoucherPage extends StatefulWidget {
  final Session session;
  const VoucherPage({Key? key, required this.session}) : super(key: key);
  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  Future<List<String>> _getVoucherList() async {
    List<String> vouchers = <String>[];

    final url = Uri.parse('http://$addr/api/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({}),
    );

    // parse the response to generate list of vouchers

    return vouchers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getVoucherList(),
      builder: (context, snapshot) {
        List<ListTile> voucherTiles = <ListTile>[];
        if (snapshot.hasData) {
          List<String> rawVouchers = snapshot.data!;
          rawVouchers.forEach((element) {
            voucherTiles.add(ListTile(
                //title, subtitle, color, etc.
                ));
          });
        }
        return Column();
      },
    );
  }
}
