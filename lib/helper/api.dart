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

  /// get token
  token() async {
    final apiHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = {
      'key': '$mySecKey.$pubKey',
    };

    var response = await http
        .post(
          Uri.parse('${base}encrypt/keys'),
          headers: apiHeaders,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));
    final resp = response.body;
    final res = jsonDecode(resp);
    if (res['status'] != null) {
      if (res['status'] == 'SUCCESS') {
        return res['data']['EncryptedSecKey']['encryptedKey'];
      }
    }

    return;
  }

  /// post call
  Future<dynamic> postCall({
    required String endpoint,
    required data,
  }) async {
    // get token
    String token = await this.token();
    if (token.isNotEmpty) {
      final apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

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
  }

  /// get call
  Future<dynamic> getCall({
    required String endpoint,
    required String? query,
  }) async {
    // get token
    String token = await this.token();
    if (token.isNotEmpty) {
      final apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

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
}
