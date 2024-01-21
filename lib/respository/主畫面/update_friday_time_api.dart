import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class UpdateFridayTimeApiResponse {
  final String event;
  final bool success;
  final String message;
  final Map<String, dynamic>? result;

  UpdateFridayTimeApiResponse({
    required this.event,
    required this.success,
    required this.message,
    this.result,
  });

  factory UpdateFridayTimeApiResponse.fromJson(Map<String, dynamic> json) {
    return UpdateFridayTimeApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'] as Map<String, dynamic>?,
    );
  }
}

class UpdateFridayTimeApi {
  Future<UpdateFridayTimeApiResponse> updateFridayTime(int orderId, int orderType) async {
    UserData loginResult = UserDataSingleton.instance;

    try {
      String url = '$baseUrl/app/api/others/meter_date/$orderId/?order_type=$orderType';

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return UpdateFridayTimeApiResponse.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to update Friday time: ${response.statusCode}');
      }
    } catch (e) {
      print("@=== Update Friday Time Error: $e");
      return UpdateFridayTimeApiResponse(
        event: "putClickMeterDate",
        success: false,
        message: "Failed to update Friday time: $e",
        result: null,
      );
    }
  }
}
