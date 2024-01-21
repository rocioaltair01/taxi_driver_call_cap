import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class ArrivedDestinationApiResponse {
  final String event;
  final bool success;
  final String message;
  final bool result;

  ArrivedDestinationApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory ArrivedDestinationApiResponse.fromJson(Map<String, dynamic> json) {
    return ArrivedDestinationApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}

// 到達目的地
class ArrivedDestinationApi {
  Future<ArrivedDestinationApiResponse> markArrivedDestination(
  {
    required int orderId,
    required int orderType,
    required Function(String res) onError
  }) async {
    UserData loginResult = UserDataSingleton.instance;
    try {
      String url = '$baseUrl/app/api/socket/click_arrive_location/$orderId?order_type=0'
          '$orderType';

      final Map<String, dynamic> body = {
        "milage": 1,
        "routeSecond": 12,
        "actualPrice":12
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
        return ArrivedDestinationApiResponse.fromJson(decodedResponse);
      } else {
        final decodedResponse = json.decode(response.body);
        onError(response.body);
        return ArrivedDestinationApiResponse(
            event: decodedResponse['event'],
          success:false,
          message: decodedResponse['error']['message'],
          result: decodedResponse['result'],
        );
      }
    } catch (e) {
      return ArrivedDestinationApiResponse(
        event: 'putClickArriveLocation',
        success: false,
        message: 'Failed to mark arrived destination: $e',
        result: false,
      );
    }
  }
}
