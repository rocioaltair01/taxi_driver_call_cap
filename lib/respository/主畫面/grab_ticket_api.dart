import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user_data_singleton.dart';

class GrabTicketResponse {
  final String event;
  final bool success;
  final GrabTicketError? error;
  final String? message;

  GrabTicketResponse({
    required this.event,
    required this.success,
    this.error,
    this.message,
  });

  factory GrabTicketResponse.fromJson(Map<String, dynamic> json) {
    return GrabTicketResponse(
      event: json['event'],
      success: json['success'],
      error: json['error'] != null ? GrabTicketError.fromJson(json['error']) : null,
      message: json['message']
    );
  }
}

class GrabTicketError {
  final String message;

  GrabTicketError({required this.message});

  factory GrabTicketError.fromJson(Map<String, dynamic> json) {
    return GrabTicketError(
      message: json['message'],
    );
  }
}

class GrabTicketApi {
  static Future<GrabTicketResponse> grabTicket({
    required String orderId,
    required int time,
    required int status,
    required Function(String res) onError
  }) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('https://test-fleet-of-taxi.shopinn.tw/api/grab');

    final Map<String, dynamic> requestBody = {
      "orderId": orderId,
      "time": time,
      "status": 0,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'accept': 'application/json',
          'x-access-token': loginResult.token,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode != 400) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final grabTicketResult = GrabTicketResponse.fromJson(jsonData);

        return grabTicketResult;
      } else {
        onError(response.body);
        print("@=== Grab Ticket Failed: Failed to grab ticket ${response.statusCode}");
        throw Exception('Failed to grab ticket');
      }
    } catch (error) {
      print("@=== Grab Ticket Error: Failed to grab ticket: $error");
      throw Exception('Failed to grab ticket: $error');
    }
  }
}
