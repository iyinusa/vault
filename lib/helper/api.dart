import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constant.dart';

class Api {
  /////////////// POST /////////////////////
  Future<dynamic> post({
    required String endpoint,
    required data,
  }) async {
    try {
      var response = await http
          .post(
            Uri.parse(base + endpoint),
            headers: apiHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      return response.body;
    } catch (e) {
      // print(e.toString());
    }
  }

  /////////////// GETS /////////////////////
  Future<dynamic> gets({
    required String endpoint,
    required String? query,
  }) async {
    if (query != '') {
      endpoint += '?${query!}';
    }
    try {
      var response = await http
          .get(
            Uri.parse(base + endpoint),
            headers: apiHeaders,
          )
          .timeout(const Duration(seconds: 10));
      return response.body;
    } catch (e) {
      // print(e.toString());
    }
  }
}
