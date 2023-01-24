import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: const [
          CameraHelper(),
          //buttons to voucher shop, settings, account page
        ]),
      ),
    );
  }
}

class CameraHelper extends StatefulWidget {
  const CameraHelper({super.key});

  @override
  State<CameraHelper> createState() => _CameraHelperState();
}

class _CameraHelperState extends State<CameraHelper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.camera.request(),
      builder: (context, snapshot) {
        Widget child = const Text('Waiting for camera permission...');
        if (snapshot.hasData) {
          PermissionStatus? status = snapshot.data;
          if (status == null) {
            child = const Text('Error while acquiring camera permission.');
          } else {
            if (status.isGranted) {
              child = FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return const Text('No cameras found.');
                    } else {
                      return TakePictureScreen(camera: snapshot.data!.first);
                    }
                  } else {
                    return const Text('Searching for available cameras...');
                  }
                },
              );
            } else if (status.isDenied) {
              child = const Text('Camera permission denied.');
            } else if (status.isPermanentlyDenied) {
              child = const Text(
                  'Camera permission permanently denied. Please allow Camera permission through Settings.');
            }
          }
        } else if (snapshot.hasError) {
          child = Text('Error: ${snapshot.error}');
        } else {
          //waiting for the result
          child = const Text('Waiting for user\'s permission...');
        }
        return child;
      },
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// IconButton(
//         icon: const Icon(Icons.camera_alt),
//         // Provide an onPressed callback.
//         onPressed: () async {
//           // Take the Picture in a try / catch block. If anything goes wrong,
//           // catch the error.
//           try {
//             // Ensure that the camera is initialized.
//             await _initializeControllerFuture;

//             // Attempt to take a picture and get the file `image`
//             // where it was saved.
//             final image = await _controller.takePicture();

//             if (!mounted) return;

//             // If the picture was taken, display it on a new screen.
//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(
//                   // Pass the automatically generated path to
//                   // the DisplayPictureScreen widget.
//                   imagePath: image.path,
//                 ),
//               ),
//             );
//           } catch (e) {
//             // If an error occurs, log the error to the console.
//             print(e);
//           }
//         },
//       );

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
