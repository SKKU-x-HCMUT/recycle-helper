import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:recycle_helper/constants.dart';
import 'package:recycle_helper/session.dart';

class RewardPage extends StatefulWidget {
  final Session session;
  const RewardPage({Key? key, required this.session}) : super(key: key);
  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  Future<List<dynamic>> _getRewards() async {
    final response = await widget.session.get("$addr/api/rewards");
    List<dynamic> vouchers = json.decode(response.body);
    return vouchers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getRewards(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading rewards...");

        List<Widget> rewardTiles = <Widget>[];

        List<dynamic> rewards = snapshot.data!;
        for (final reward in rewards) {
          rewardTiles.add(Card(
            child: ListTile(
              title: Text(reward['name']),
              subtitle: Text("${reward['pointsExchange']} Points"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return RewardDetailPage(
                      session: widget.session,
                      rewardId: reward["rewardId"],
                    );
                  },
                ));
              },
            ),
          ));
        }
        return Column(
          children: rewardTiles,
        );
      },
    );
  }
}

class RewardDetailPage extends StatefulWidget {
  final Session session;
  final String rewardId;

  const RewardDetailPage(
      {Key? key, required this.session, required this.rewardId})
      : super(key: key);

  @override
  State<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends State<RewardDetailPage> {
  Future<dynamic> _getVoucher(String voucherId) async {
    final response = await widget.session.get("$addr/api/voucher/$voucherId");
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> _getRewardInfo(String rewardId) async {
    final response = await widget.session.get("$addr/api/reward/$rewardId");
    final decodedResponse = json.decode(response.body);

    //get info of vouchers under the reward
    List<Map> vouchers = [];
    Map rawVouchers = decodedResponse["vouchers"];

    for (final entry in rawVouchers.entries) {
      int quantity = entry.value['quantity'];
      final voucher = await _getVoucher(entry.key);

      //just repeat to add as quantity
      for (int i = 0; i < quantity; i++) {
        vouchers.add(voucher);
      }
    }

    return {
      "name": decodedResponse["name"],
      "pointsExchange": decodedResponse["pointsExchange"],
      "vouchers": vouchers,
    };
  }

  Future<void> _achieveReward() async {
    final response = await widget.session.post(
        "$addr/api/user/achieve-reward",
        json.encode({
          "rewardId": widget.rewardId,
          "localId": widget.session.localId,
        }));

    // final decodedResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You achieved the reward!")),
        );
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reward Detail')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getRewardInfo(widget.rewardId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> detailTiles = [];

              Map<String, dynamic> rewardInfo = snapshot.data!;

              //name
              detailTiles.add(Card(
                child: ListTile(
                  leading: const Text("Name"),
                  title: Text(rewardInfo['name']),
                ),
              ));

              //points
              detailTiles.add(Card(
                child: ListTile(
                  leading: const Text("Required Points"),
                  title: Text(rewardInfo['pointsExchange'].toString()),
                ),
              ));

              //divider
              detailTiles.add(const ListTile(title: Text("Included Vouchers")));

              //vouchers
              List<Map> vouchers = rewardInfo['vouchers'];
              for (final voucher in vouchers) {
                detailTiles.add(
                  Card(
                    child: ListTile(
                      title: Text(voucher['storeName']),
                      subtitle: Text(voucher['name']),
                    ),
                  ),
                );
              }
              return Column(
                  children: detailTiles +
                      [
                        ElevatedButton(
                          onPressed: () => _achieveReward(),
                          child: const Text('Achieve Reward'),
                        ),
                      ]);
            } else {
              return const Text("Reward Detail loading...");
            }
          },
        ),
      ),
    );
  }
}


// class VoucherDetailPage extends StatelessWidget {
//   const VoucherDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
