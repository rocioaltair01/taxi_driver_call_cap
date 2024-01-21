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
        final decodedResponse = json.decode(response.body);
        return UpdatePasswordApiResponse(
          event: decodedResponse['event'],
          success: false,
          message: decodedResponse['error']['message'],
          result: decodedResponse['result'],
        );
      }
    } catch (e) {
      return UpdatePasswordApiResponse(
        event: 'updateDriverPassword',
        success: false,
        message: 'Failed to update password: $e',
        result: '',
      );
    }
  }
}
