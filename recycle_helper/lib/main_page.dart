import 'package:flutter/material.dart';
import 'package:recycle_helper/capture_page.dart';
import 'package:recycle_helper/voucher_page.dart';
import 'package:recycle_helper/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 1;

  static const List<Widget> _pages = <Widget>[
    VoucherPage(),
    CameraLoader(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: _pages.elementAt(_selectedPageIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Voucher Shop',
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
