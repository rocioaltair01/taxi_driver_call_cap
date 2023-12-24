
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/歷史訂單/immediate_list_model.dart';
import '../../model/user_data_singleton.dart';
import '../../model/預約單/reservation_model.dart';

class ReservationResponse {
  final int statusCode;
  List<BillList> data;

  ReservationResponse({required this.statusCode, required this.data});
}

class ReservationApi {
  static Future<ReservationResponse> getReservationTickets(int year, int month, String task) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/reservation/list?task=${task}&per_page=10&current_page=1year=${year.toString()}&month=${month.toString()}');
    //https://test-taxi.shopinn.tw/app/api/reservation/list?task=ungrabbed&per_page=10&current_page=1&year=2023&month=12
    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        print("aaa ${response.body}");
        final jsonData = json.decode(response.body);
        final ReservationList reservationData = ReservationList.fromJson(jsonData);

        return ReservationResponse(statusCode: response.statusCode, data: reservationData.result.billList);
      } else {
        throw Exception('Failed to fetch data11');
      }
    } catch (error) {
      throw Exception('Failed to fetch data11: $error');
    }
  }
}