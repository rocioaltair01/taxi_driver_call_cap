import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class UpdateUserImageResponse {
  final String event;
  final bool success;
  final String message;
  final String result;

  UpdateUserImageResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory UpdateUserImageResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserImageResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}

class UpdateUserImageApi {
  static Future<UpdateUserImageResponse> updateUserImage({
    required String filePath,
    required String type,
    required Function() onSuccess,
    required Function(String res) onError,
    required Function() onNetworkError
  }) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/app/api/driver/upload/info/?type=info');

    try {
      final File imageFile = File(filePath);

      final request = http.MultipartRequest('POST', uri)
        ..headers['x-access-token'] = loginResult.token
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseJson = await http.Response.fromStream(response);

        final jsonData = json.decode(responseJson.body) as Map<String, dynamic>;
        final updateUserImageResult = UpdateUserImageResponse.fromJson(jsonData);

        onSuccess();
        return updateUserImageResult;
      } else {
        final responseJson = await http.Response.fromStream(response);
        onError(responseJson.body);
        throw Exception('Failed to update user image');
      }
    } catch (error) {
      onNetworkError();
      print("@=== Update User Image Error: Failed to update user image: $error");
      throw Exception('Failed to update user image: $error');
    }
  }
}
