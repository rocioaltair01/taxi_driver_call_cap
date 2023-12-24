import 'dart:convert';
import 'package:http/http.dart' as http;

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
  Future<GiveupErrorResponse> cancelOrderApply(int orderId, int orderType) async {
    UserData loginResult = UserDataSingleton.instance;
    print("give up orderId $orderId");
    try {
      String url = 'https://test-taxi.shopinn.tw/app/api/driver/order/cancel_apply/$orderId';

        final response = await http.put(
          Uri.parse(url),
          headers: {
            'x-access-token': loginResult.token,
          },
        );


        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print("give up ${response.body}");
          return GiveupErrorResponse.fromJson(decodedResponse);
        } else {
          final decodedResponse = json.decode(response.body);
          print("give up 3 ${response.body}");
          return GiveupErrorResponse(
            event : decodedResponse['event'],
            success : decodedResponse['success'],
            message : decodedResponse['error']['message'],
            result : '',
          );
      }

    } catch (e) {
      print("jk;");
      return GiveupErrorResponse(
        event: "updateApplyCancel",
        success: false,
          message: '',
          result: ''
      );
    }
  }
}
