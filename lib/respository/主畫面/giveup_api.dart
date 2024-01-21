import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class GiveupErrorResponse {
  final String event;
  final bool success;
  final String message;
  final String result;

  GiveupErrorResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory GiveupErrorResponse.fromJson(Map<String, dynamic> json) {
    return GiveupErrorResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}


class GiveupApi {
  Future<GiveupErrorResponse> cancelOrderApply(
      int orderId,
      int orderType,
      Function(String res) onError
      ) async {
    UserData loginResult = UserDataSingleton.instance;
    print("@=== give up orderId $orderId");
    try {
      String url = '$baseUrl/app/api/driver/order/cancel_apply/$orderId';

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'x-access-token': loginResult.token,
          },
        );

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          return GiveupErrorResponse.fromJson(decodedResponse);
        } else {
          onError(response.body);
          throw Exception('Failed cancelOrderApply');
      }
    } catch (e) {
      throw Exception('Failed cancelOrderApply');
    }
  }
}
