import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/constants/constants.dart';

import '../../model/user_data_singleton.dart';

class StartPickingPassengerApiResponse {
  final String event;
  final bool success;
  final String message;
  final bool result;

  StartPickingPassengerApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory StartPickingPassengerApiResponse.fromJson(Map<String, dynamic> json) {
    return StartPickingPassengerApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}
// 已載乘客
class StartPickingPassengerApi {
  Future<StartPickingPassengerApiResponse> startPickingPassenger(int orderId) async {
    UserData loginResult = UserDataSingleton.instance;
    try {
      String url = '$baseUrl/app/api/socket/click_take_passen/$orderId?order_type=1';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print("response.body ${response.body}");
        return StartPickingPassengerApiResponse.fromJson(decodedResponse);
      } else {
        final decodedResponse = json.decode(response.body);
        print("response.body ${response.body}");
        return StartPickingPassengerApiResponse.fromJson(decodedResponse);
      }
    } catch (e) {
      print("faied $e");
      return StartPickingPassengerApiResponse(
        event: "putClickTakePassen",
        success: false,
        message: "Failed to start picking passenger: $e",
        result: false,
      );
    }
  }
}
