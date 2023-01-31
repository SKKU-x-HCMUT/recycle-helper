import 'package:flutter/material.dart';
import 'package:recycle_helper/authentication.dart';
import 'package:recycle_helper/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //login_state = false

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Recycle Helper",
      home: //check login state and go to loginpage or mainpage
          //if(login_state == false) LoginPage()
          MainPage(),
    );
  }
}

// class PermissionHandlerPage extends StatefulWidget {
//   const PermissionHandlerPage({super.key});

//   @override
//   State<PermissionHandlerPage> createState() => _PermissionHandlerPageState();
// }

// class _PermissionHandlerPageState extends State<PermissionHandlerPage> {
//   Future<void> _handlePermission() async {
//     final status = await Permission.camera.request();

//     if (status.isGranted) {
//       // Permission has been granted.
//       print('Permission Granted');
//     } else if (status.isDenied) {
//       // We didn't ask for permission yet
//       // or the permission has been denied before but not permanently.
//       print('Permission denied');
//     } else if (status.isPermanentlyDenied) {
//       // Permission has been denied before but not permanently.
//       print('Permission Permanently Denied');
//       await openAppSettings();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Permission Required')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton(
//           onPressed: _requestCameraPermission,
//           child: const Text('Request Runtime Camera Permission'),
//         ),
//       ),
//     );
//   }
// }
