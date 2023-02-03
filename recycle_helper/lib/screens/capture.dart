import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:recycle_helper/session.dart';
import 'package:recycle_helper/constants.dart';

// 1. CameraPermissionChecker first check for the permission
class CameraPermissionChecker extends StatefulWidget {
  final Session session;
  const CameraPermissionChecker({Key? key, required this.session})
      : super(key: key);
  @override
  State<CameraPermissionChecker> createState() =>
      _CameraPermissionCheckerState();
}

class _CameraPermissionCheckerState extends State<CameraPermissionChecker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.camera.request(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PermissionStatus? status = snapshot.data;
          if (status == null) {
            return const Text('Error while acquiring camera permission.');
          }
          if (status.isDenied) {
            return const Text('Camera permission denied.');
          }
          if (status.isPermanentlyDenied) {
            return const Text(
                'Camera permission permanently denied. Please allow Camera permission through Settings.');
          }
          if (status.isGranted) {
            return FutureBuilder<List<CameraDescription>>(
              future: availableCameras(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return const Text('Camera permission denied.');
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return const Text('No camera available.');
                    } else {
                      return CameraScreen(
                        session: widget.session,
                        camera: snapshot.data!.first,
                      );
                    }
                  }
                } else {
                  return const Text('Searching for available cameras...');
                }
              },
            );
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const Text('Checking camera permission...');
      },
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  final Session session;
  final CameraDescription camera;

  const CameraScreen({
    super.key,
    required this.session,
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
            session: widget.session,
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
  final Session session;
  final String imagePath;
  const CaptureResultScreen({
    super.key,
    required this.session,
    required this.imagePath,
  });

  Future<String?> _getPredictionResult() async {
    final http.StreamedResponse response;
    try {
      response = await session.multipartRequest('$addr/api/predict', imagePath);
      if (response.statusCode == 200) {
        final responseBytes = await response.stream.toBytes();
        final responseBody = utf8.decode(responseBytes);
        return responseBody;
      } else {
        final responseBytes = await response.stream.toBytes();
        final responseBody = utf8.decode(responseBytes);
        print(responseBody);
        throw Exception('_getPredictionResult() failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: FutureBuilder<String?>(
        future: _getPredictionResult(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final predictionResult = json.decode(snapshot.data!);

            return Column(
              children: [
                Image.file(File(imagePath)),
                Text(
                  predictionResult["type"].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${(predictionResult["confidence"] * 100).round()}%",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Image.file(File(imagePath)),
                const Text("Loading prediction result..."),
              ],
            );
          }
        },
      ),
      //Image.file(),
    );
  }
}
