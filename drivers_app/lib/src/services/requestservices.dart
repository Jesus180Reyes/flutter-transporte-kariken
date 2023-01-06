import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static getRequest(Uri url) async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String jsonData = response.body;
      final decodeData = jsonDecode(jsonData);
      return decodeData;
    } else {
      return "failed";
    }
  }
}
