import 'package:flutter/material.dart';
import 'package:recycle_helper/capture_page.dart';
import 'package:recycle_helper/reward_page.dart';
import 'package:recycle_helper/my_page.dart';
import 'package:recycle_helper/session.dart';

class MainFrame extends StatefulWidget {
  final Session session;
  const MainFrame({Key? key, required this.session}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _selectedPageIndex = 1;

  List<Widget> _getPages() => <Widget>[
        VoucherPage(session: widget.session),
        CameraLoader(session: widget.session),
        MyPage(session: widget.session),
      ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _getPages();
    return Scaffold(
      appBar: AppBar(title: const Text('Main')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: pages.elementAt(_selectedPageIndex)),
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
