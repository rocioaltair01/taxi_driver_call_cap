import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class CreateTicketHistoryPriceApiResponse {
  final String event;
  final bool success;
  final String message;
  final bool result;

  CreateTicketHistoryPriceApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory CreateTicketHistoryPriceApiResponse.fromJson(Map<String, dynamic> json) {
    return CreateTicketHistoryPriceApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}

class CreateTicketHistoryPriceApi {
  Future<CreateTicketHistoryPriceApiResponse> createTicketHistoryPrice(int orderId, Map<String, dynamic> requestBody) async {
    UserData loginResult = UserDataSingleton.instance;

    try {
      String url = '$baseUrl/app/api/order_record/$orderId';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'x-access-token': loginResult.token,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print("Create Ticket History Price Response: ${response.body}");
        return CreateTicketHistoryPriceApiResponse.fromJson(decodedResponse);
      } else {
        print("Create Ticket History Price Failed: ${response.body}");
        throw Exception('Failed to create ticket history price: ${response.statusCode}');
      }
    } catch (e) {
      print("Create Ticket History Price Error: $e");
      return CreateTicketHistoryPriceApiResponse(
        event: "postOrderRecord",
        success: false,
        message: "Failed to create ticket history price: $e",
        result: false,
      );
    }
  }
}
