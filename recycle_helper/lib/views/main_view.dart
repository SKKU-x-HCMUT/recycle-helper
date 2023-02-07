import 'package:flutter/material.dart';

import 'package:recycle_helper/session.dart';

import 'package:recycle_helper/views/capture_view.dart';
import 'package:recycle_helper/views/point_shop_view.dart';
import 'package:recycle_helper/views/user_view.dart';

class MainView extends StatefulWidget {
  final Session session;
  const MainView({Key? key, required this.session}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    const List<String> titles = <String>["Point Shop", "Capture", "User"];

    final List<Widget> pages = <Widget>[
      PointShopPage(session: widget.session),
      CameraPermissionChecker(session: widget.session),
      UserPage(session: widget.session),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles.elementAt(currentPageIndex))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(child: pages.elementAt(currentPageIndex)),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.shop),
            label: 'Reward Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Capture',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
      ),
    );
  }
}
