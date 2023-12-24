import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';
import '../../model/歷史訂單/reservation_list_model.dart';

class FetchDataResponse {
  final int statusCode;
  final List<ReservationInfo> data;

  FetchDataResponse({required this.statusCode, required this.data});
}

class ReservationTicketApi {
  static Future<FetchDataResponse> getReservationTickets(int year, int month) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/reservation/list?task=all&per_page=25&current_page=1&year=${year.toString()}&month=${month.toString()}');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ReservationListModel reservationData = ReservationListModel.fromJson(jsonData['result']);

        return FetchDataResponse(statusCode: response.statusCode, data: reservationData.billList);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  static Future<FetchDataResponse> getOngoingReservationTickets(bool grabbed) async {
    UserData loginResult = UserDataSingleton.instance;
    String queryGrabbed = grabbed ? 'grabbed' : 'ungrabbed';
    print("hey : $baseUrl/app/api/reservation/list?task=$queryGrabbed&per_page=25&current_page=1");
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/reservation/list?task=$queryGrabbed&per_page=25&current_page=1');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ReservationListModel reservationData = ReservationListModel.fromJson(jsonData['result']);

        return FetchDataResponse(statusCode: response.statusCode, data: reservationData.billList);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
}
