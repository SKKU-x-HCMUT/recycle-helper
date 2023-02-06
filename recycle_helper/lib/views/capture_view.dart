import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

import 'package:recycle_helper/constants.dart';
import 'package:recycle_helper/session.dart';

import 'package:permission_handler/permission_handler.dart';

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
            return CameraLoader(session: widget.session);
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const Text('Checking camera permission...');
      },
    );
  }
}

// 2. CameraLoader loads Camera after Permission is checked
class CameraLoader extends StatefulWidget {
  final Session session;

  const CameraLoader({Key? key, required this.session}) : super(key: key);

  @override
  State<CameraLoader> createState() => _CameraLoaderState();
}

class _CameraLoaderState extends State<CameraLoader> {
  @override
  Widget build(BuildContext context) {
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
              return PreviewScreen(
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
}

// 3. Finally screen shows that allows users to take a picture using a given camera.
class PreviewScreen extends StatefulWidget {
  final Session session;
  final CameraDescription camera;

  const PreviewScreen({
    super.key,
    required this.session,
    required this.camera,
  });

  @override
  PreviewScreenState createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void _capture() async {
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
      ResolutionPreset.low,
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
          child: const Text('Scan'),
        ),
      ],
    );
  }
}

// A widget that displays the picture taken by the user.
class CaptureResultScreen extends StatefulWidget {
  final Session session;
  final String imagePath;
  const CaptureResultScreen({
    super.key,
    required this.session,
    required this.imagePath,
  });

  @override
  State<CaptureResultScreen> createState() => _CaptureResultScreenState();
}

class _CaptureResultScreenState extends State<CaptureResultScreen> {
  Future<String?> _getPredictionResult() async {
    // final http.StreamedResponse response;
    // try {
    //   response = await widget.session
    //       .multipartRequest('$addr/api/predict', widget.imagePath);
    //   if (response.statusCode == 200) {
    //     final responseBytes = await response.stream.toBytes();
    //     final responseBody = utf8.decode(responseBytes);
    //     return responseBody;
    //   } else {
    //     print(response.reasonPhrase);
    //     // final responseBytes = await response.stream.toBytes();
    //     // final responseBody = utf8.decode(responseBytes);
    //     // print(responseBody);
    //     throw Exception('_getPredictionResult() failed');
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // return null;
    return "";
  }

  String _getMarkPath(String country, String type) {
    String markPath = "assets/marks/$country/";
    switch (type) {
      case "cardboard":
        markPath += "cardboard.jpeg";
        break;

      case "glass":
        markPath += "glass.jpg";
        break;

      case "metal":
        markPath += "metal.jpg";
        break;

      case "plastic":
        markPath += "plastic.jpg";
        break;
      default:
        markPath += "dirty.jpg";
        break;
    }
    return markPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),

      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<String?>(
            future: _getPredictionResult(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  children: [
                    Image.file(File(widget.imagePath)),
                    const Text("Loading prediction result..."),
                  ],
                );
              }

              //final predictionResult = json.decode(snapshot.data!);
              Map predictionResult = {
                "type": "plastic",
                "confidence": 0.87,
              };

              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image(
                      image: AssetImage(
                          _getMarkPath("ko", predictionResult["type"])),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Text(
                    predictionResult["type"].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Confidence: ${(predictionResult["confidence"] * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Congratulations! You earned 5 points!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      //Image.file(),
    );
  }
}
