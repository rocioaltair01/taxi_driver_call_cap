import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class GrabReservationApi {
  static Future<UpdateDriverGrabReservationResponse> grabReservation(
      int number,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/reservation/grab/${number.toString()}');
    //https://test-taxi.shopinn.tw/app/api/reservation/list?task=ungrabbed&per_page=10&current_page=1&year=2023&month=12
    try {
      final response = await http.put(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final UpdateDriverGrabReservationResponse reservationData = UpdateDriverGrabReservationResponse.fromJson(jsonData);

        return reservationData;
      } else {
        onError(response.body);
        throw Exception('Failed to fetch data11');
      }
    } catch (error) {
      onNetworkError();
      throw Exception('Failed to fetch data11: $error');
    }
  }
}

class UpdateDriverGrabReservationResponse {
  final String event;
  final bool success;
  final String message;
  final Result result;

  UpdateDriverGrabReservationResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory UpdateDriverGrabReservationResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDriverGrabReservationResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final bool success;
  final String message;

  Result({
    required this.success,
    required this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      success: json['success'],
      message: json['message'],
    );
  }
}
