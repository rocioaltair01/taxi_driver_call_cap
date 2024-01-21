import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';
import '../../model/歷史訂單/reservation_ticket_detail_model.dart';

class ReservationTicketDetailResponse {
  final int statusCode;
  ReservationTicketDetailModel? data;

  ReservationTicketDetailResponse({required this.statusCode, this.data});
}

//提取單一立即單-成功
class ReservationTicketDetailApi {
  static Future<ReservationTicketDetailResponse> getReservationTicketDetail(int orderId) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/app/api/reservation/detail/$orderId');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ticketDetail = ReservationTicketDetailModel.fromJson(jsonData);
        return ReservationTicketDetailResponse(statusCode: response.statusCode, data: ticketDetail);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }
}
