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
  Future<List<dynamic>> _getVouchers() async {
    final response = await widget.session.get("http://$addr/api/vouchers");
    List<dynamic> vouchers = json.decode(response.body);
    return vouchers;
  }

  Future<dynamic> _getVoucher(String voucherId) async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getVouchers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> voucherTiles = <Widget>[];

          List<dynamic> vouchers = snapshot.data!;
          for (final voucher in vouchers) {
            voucherTiles.add(Card(
              child: ListTile(
                title: Text(voucher['storeName']),
                subtitle: Text(voucher['name']),
              ),
            ));
          }
          return Column(
            children: voucherTiles,
          );
        } else {
          return const Text("Loading vouchers...");
        }
      },
    );
  }
}
