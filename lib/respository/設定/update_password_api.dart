import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class UpdatePasswordApiResponse {
  final String event;
  final bool success;
  final String message;
  final String result;

  UpdatePasswordApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory UpdatePasswordApiResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}

class UpdatePasswordApi {
  Future<UpdatePasswordApiResponse> updatePassword(
      String newPassword,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    UserData loginResult = UserDataSingleton.instance;

    try {
      String url = '$baseUrl/app/api/driver/password';

      final Map<String, dynamic> body = {
        "password": newPassword,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': loginResult.token,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return UpdatePasswordApiResponse.fromJson(decodedResponse);
      } else {
        onError(response.body);
        throw Exception('Failed updatePassword: ${response.statusCode}');
      }
    } catch (e) {
      onNetworkError();
      throw Exception('Failed updatePassword');
    }
  }
}
