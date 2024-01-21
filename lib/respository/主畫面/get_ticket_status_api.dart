import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
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
  Future<GetTicketStatusApiResponse> getTicketStatus(
      int orderId,
      int orderType,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    UserData loginResult = UserDataSingleton.instance;

    try {
      String url = '$baseUrl/app/api/order/condition/$orderId/?order_type=$orderType';
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
        onError(response.body);
        throw Exception('Failed GetTicketStatusApi');
      }
    } catch (e) {
      print("@=== Failed $e");
      onNetworkError();
      throw Exception('Failed GetTicketStatusApi');
    }
  }
}
