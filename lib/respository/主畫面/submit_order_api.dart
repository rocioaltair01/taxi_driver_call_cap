import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class SubmitOrderResponse {
  final String event;
  final bool success;
  final Map<String, dynamic>? result;

  SubmitOrderResponse({
    required this.event,
    required this.success,
    this.result,
  });

  factory SubmitOrderResponse.fromJson(Map<String, dynamic> json) {
    return SubmitOrderResponse(
      event: json['event'],
      success: json['success'],
      result: json['result'] as Map<String, dynamic>?,
    );
  }
}

class SubmitOrderApi {
  static Future<SubmitOrderResponse> submitOrder({
    required int? passengerNum,
    required String? passengerComment,
    required String? register,
    required double? onLocationLng,
    required double? onLocationLat,
    required double? offLocationLng,
    required double? offLocationLat,
    required int? cars,
    required List<String>? designationDriver,
    required List<String>? blackDriver,
    required int? customerId,
    required int? passengerId,
    required String? onLocation,
    required String? offLocation,
    required int? searchInterval, required serviceList,
  }) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/test-fleet-of-taxi.shopinn.tw/api/submit-order');

    final Map<String, dynamic> requestBody = {
      "passengerNum": passengerNum ?? 0, // Provide a default value or handle it according to your logic
      "passengerComment": passengerComment ?? "",
      "register": register ?? "",
      "onLocationLng": onLocationLng ?? 0.0,
      "onLocationLat": onLocationLat ?? 0.0,
      "offLocationLng": offLocationLng ?? 0.0,
      "offLocationLat": offLocationLat ?? 0.0,
      "serviceList": null,
      "cars": cars ?? 0, // Provide a default value or handle it according to your logic
      "designationDriver": designationDriver ?? [],
      "blackDriver": blackDriver ?? [],
      "customerId": customerId ?? 0, // Provide a default value or handle it according to your logic
      "passengerId": passengerId ?? 0, // Provide a default value or handle it according to your logic
      "onLocation": onLocation ?? "",
      "offLocation": offLocation ?? "",
      "searchInterval": searchInterval ?? 0, // Provide a default value or handle it according to your logic
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

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final submitOrderResult = SubmitOrderResponse.fromJson(jsonData);

        return submitOrderResult;
      } else {
        print("@=== Submit Order Failed: Failed to submit order");
        throw Exception('Failed to submit order');
      }
    } catch (error) {
      print("@=== Submit Order Error: Failed to submit order: $error");
      throw Exception('Failed to submit order: $error');
    }
  }
}
