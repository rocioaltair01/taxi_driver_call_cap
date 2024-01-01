import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../model/user_data_singleton.dart';

class GrabTicketResponse {
  final String event;
  final bool success;
  final String message;

  GrabTicketResponse({
    required this.event,
    required this.success,
    required this.message,
  });

  factory GrabTicketResponse.fromJson(Map<String, dynamic> json) {
    return GrabTicketResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
    );
  }
}

class GrabTicketApi {
  static Future<GrabTicketResponse> grabTicket(String orderId, int time, int status) async {
    final Uri uri = Uri.parse('https://test-fleet-of-taxi.shopinn.tw/api/grab');
    UserData loginResult = UserDataSingleton.instance;
    Map<String, dynamic> requestBody = {
      'orderId': orderId,
      'time': time,
      'status': status,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GrabTicketResponse.fromJson(jsonData);
      } else {
        print("Grab Ticket API: Failed ${response.statusCode}");
        throw Exception('Failed to grab ticket');
      }
    } catch (error) {
      print("Grab Ticket API: Error $error");
      throw Exception('Failed to grab ticket: $error');
    }
  }
}
