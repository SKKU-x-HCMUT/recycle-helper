import 'package:flutter/material.dart';

import 'package:recycle_helper/session.dart';

import 'package:recycle_helper/views/capture.dart';
import 'package:recycle_helper/views/point_shop_view.dart';
import 'package:recycle_helper/views/user_view.dart';

class MainView extends StatefulWidget {
  final Session session;
  const MainView({Key? key, required this.session}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    const List<String> titles = <String>["Point Shop", "Capture", "My Page"];

    final List<Widget> pages = <Widget>[
      PointShopPage(session: widget.session),
      CameraPermissionChecker(session: widget.session),
      MyPage(session: widget.session),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles.elementAt(_selectedPageIndex))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(child: pages.elementAt(_selectedPageIndex)),
        ),
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
