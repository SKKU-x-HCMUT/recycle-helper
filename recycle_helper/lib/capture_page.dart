import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CapturePage extends StatelessWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CameraLoader();
  }
}

class CameraLoader extends StatefulWidget {
  const CameraLoader({super.key});

  @override
  State<CameraLoader> createState() => _CameraLoaderState();
}

class _CameraLoaderState extends State<CameraLoader> {
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
                      return CameraScreen(camera: snapshot.data!.first);
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
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    super.key,
    required this.camera,
  });

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void _capture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CaptureResultScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

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
    return Column(
      children: [
        FutureBuilder<void>(
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
        ),
        ElevatedButton(
          onPressed: _capture,
          child: const Text('CAPTURE'),
        ),
      ],
    );
  }
}

// A widget that displays the picture taken by the user.
class CaptureResultScreen extends StatelessWidget {
  final String imagePath;

  const CaptureResultScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
