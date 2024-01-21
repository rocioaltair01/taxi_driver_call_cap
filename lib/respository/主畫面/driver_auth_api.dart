import 'dart:convert';

import '../../constants/constants.dart';
import 'package:http/http.dart' as http;

class DriverAuthResponse {
  final String event;
  final bool success;
  final String message;
  final DriverAuthResult result;

  DriverAuthResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory DriverAuthResponse.fromJson(Map<String, dynamic> json) {
    return DriverAuthResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: DriverAuthResult.fromJson(json['result']),
    );
  }
}

class DriverAuthResult {
  final int authorize;

  DriverAuthResult({
    required this.authorize,
  });

  factory DriverAuthResult.fromJson(Map<String, dynamic> json) {
    return DriverAuthResult(
      authorize: json['authorize'] ?? 0,
    );
  }
}

class DriverAuthApi {
  static Future<DriverAuthResponse> getDriverAuth(
      String token,
      Function(String res) onError
      ) async {
    String url = "$baseUrl/app/api/driver/auth";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-access-token': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final driverAuthResponse = DriverAuthResponse.fromJson(jsonData);
        print("@=== Driver Auth Result: ${driverAuthResponse.result.authorize}");
        return driverAuthResponse;
      } else {
        onError(response.body);
        throw Exception('Failed to fetch driver authorization');
      }
    } catch (error) {
      throw Exception('Failed to fetch driver authorization: $error');
    }
  }
}
