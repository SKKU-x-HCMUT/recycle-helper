import 'dart:io';

import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {"Content-Type": "application/json"};
  String localId = "";

  Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response =
        await http.post(Uri.parse(url), body: data, headers: headers);
    return response;
  }

  Future<http.StreamedResponse> uploadPhoto(
      String url, String imagePath) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files
        .add(await http.MultipartFile.fromPath('image_file', imagePath));

    http.StreamedResponse response = await request.send();
    return response;
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
