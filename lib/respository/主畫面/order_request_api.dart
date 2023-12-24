import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class OrderRequestAboveResponse {
  final int statusCode;
  InstantListModel? data;

  OrderRequestAboveResponse({required this.statusCode, this.data});
}

class OrderRequestAboveApi {
  static Future<OrderRequestAboveResponse> getOrderRequestAbove(double lat, double lng) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/test-fleet-of-taxi.shopinn.tw/api/order-info?lat=$lat&lng=$lng');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        print("Order Request Above Response: ${response.body}");
        final jsonData = json.decode(response.body);
        final ticketDetail = InstantListModel.fromJson(jsonData['result']);

        return OrderRequestAboveResponse(statusCode: response.statusCode, data: ticketDetail);
      } else {
        print("Order Request Above Failed: Failed to fetch data");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print("Order Request Above Error: Failed to fetch data: $error");
      throw Exception('Failed to fetch data: $error');
    }
  }
}

class InstantListModel {
  final String event;
  final bool success;
  final List<dynamic> result; // Change the type to match the actual data type of "result"

  InstantListModel({
    required this.event,
    required this.success,
    required this.result,
  });

  factory InstantListModel.fromJson(Map<String, dynamic> json) {
    return InstantListModel(
      event: json['event'],
      success: json['success'],
      result: List<dynamic>.from(json['result']),
    );
  }
}