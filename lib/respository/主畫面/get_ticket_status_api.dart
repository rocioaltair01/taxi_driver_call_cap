import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user_data_singleton.dart';

class GetTicketStatusApiResponse {
  final String event;
  final bool success;
  final String message;
  final int status;

  GetTicketStatusApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.status,
  });

  factory GetTicketStatusApiResponse.fromJson(Map<String, dynamic> json) {
    return GetTicketStatusApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      status: json['result']['status'],
    );
  }
}

class GetTicketStatusApi {
  Future<GetTicketStatusApiResponse> getTicketStatus(int orderId, int orderType) async {
    UserData loginResult = UserDataSingleton.instance;

    try {
      String url = 'https://test-taxi.shopinn.tw/app/api/order/condition/$orderId/?order_type=$orderType';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return GetTicketStatusApiResponse.fromJson(decodedResponse);
      } else {
        final decodedResponse = json.decode(response.body);
        return GetTicketStatusApiResponse(
          event: decodedResponse['event'],
          success: false,
          message: decodedResponse['error']['message'],
          status: -1, // Provide a default value or handle it according to your logic
        );
      }
    } catch (e) {
      print("Failed $e");
      return GetTicketStatusApiResponse(
        event: 'getOrderCondition',
        success: false,
        message: 'Failed to get ticket status: $e',
        status: -1, // Provide a default value or handle it according to your logic
      );
    }
  }
}
