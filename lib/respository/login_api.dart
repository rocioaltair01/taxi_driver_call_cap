import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class LoginApi {
  static Future<Map<String, dynamic>> login(String account, String password, String teamCode, String firebaseToken) async {
    final loginUrl = '$baseUrl/app/api/driver/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'account': account,
          'password': password,
          'teamCode': teamCode,
          'firebaseToken': firebaseToken,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to log in');
      }
    } catch (error) {
      throw Exception('Failed to log in: $error');
    }
  }
}
