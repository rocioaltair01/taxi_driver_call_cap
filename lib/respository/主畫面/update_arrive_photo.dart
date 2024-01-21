import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';
import 'package:http_parser/http_parser.dart';

class UpdateArrivePhotoResponse {
  final String event;
  final bool success;
  final Map<String, dynamic>? result;

  UpdateArrivePhotoResponse({
    required this.event,
    required this.success,
    this.result,
  });

  factory UpdateArrivePhotoResponse.fromJson(Map<String, dynamic> json) {
    return UpdateArrivePhotoResponse(
      event: json['event'],
      success: json['success'],
      result: json['result'] as Map<String, dynamic>?,
    );
  }
}

class UpdateArrivePhotoApi {
  static Future<UpdateArrivePhotoResponse> updateArrivePhoto({
    required String filePath,
    required int orderId,
    required int orderType,
    required Function(String res) onError
  }) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/app/api/driver/upload/on_location?torder_type=$orderType&id=$orderId');

    try {
      final File photoFile = File(filePath);

      final request = http.MultipartRequest('POST', uri)
        // ..headers['accept'] = 'application/json'
        ..headers['x-access-token'] = loginResult.token
        ..files.add(await http.MultipartFile.fromPath(
            'image',
            photoFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseJson = await http.Response.fromStream(response);
        final jsonData = json.decode(responseJson.body) as Map<String, dynamic>;
        final updateArrivePhotoResult = UpdateArrivePhotoResponse.fromJson(jsonData);

        return updateArrivePhotoResult;
      } else {
        final responseJson = await http.Response.fromStream(response);
        print("@=== Update Arrive Photo Error: Failed to update arrive photo:${response.statusCode} ${responseJson.body}");
        onError(responseJson.body);
        throw Exception('Failed to update arrive photo');
      }
    } catch (error) {
      print("@=== Update Arrive Photo Error: Failed to update arrive photo: $error");
      throw Exception('Failed to update arrive photo: $error');
    }
  }
}
