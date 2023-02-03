import 'package:flutter/material.dart';
import 'package:recycle_helper/screens/capture.dart';
import 'package:recycle_helper/screens/reward.dart';
import 'package:recycle_helper/screens/user.dart';
import 'package:recycle_helper/session.dart';

class MainFrame extends StatefulWidget {
  final Session session;
  const MainFrame({Key? key, required this.session}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _selectedPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    const List<String> titles = <String>["Rewards", "Capture", "My Page"];

    final List<Widget> pages = <Widget>[
      RewardPage(session: widget.session),
      CameraPermissionChecker(session: widget.session),
      MyPage(session: widget.session),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles.elementAt(_selectedPageIndex))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: pages.elementAt(_selectedPageIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Reward Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Capture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
