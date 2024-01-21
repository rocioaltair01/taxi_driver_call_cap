import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class ReservationGrabTicketResponse {
  final int statusCode;
  UpdateDriverGrabReservationModel data;

  ReservationGrabTicketResponse({required this.statusCode, required this.data});
}

class ReservationGrabTicketApi {
  static Future<ReservationGrabTicketResponse> grabTickets(
      String ticketId,
      Function(String res) onError
      ) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/reservation/grab/$ticketId');
    try {
      final response = await http.put(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final UpdateDriverGrabReservationModel reservationData = UpdateDriverGrabReservationModel.fromJson(jsonData);

        return ReservationGrabTicketResponse(statusCode: response.statusCode, data: reservationData);
      } else {
        onError(response.body);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
}

class UpdateDriverGrabReservationModel {
  final String event;
  final bool success;
  final String message;
  final Result result;

  UpdateDriverGrabReservationModel({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory UpdateDriverGrabReservationModel.fromJson(Map<String, dynamic> json) {
    return UpdateDriverGrabReservationModel(
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

