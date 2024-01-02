import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/歷史訂單/immediate_ticket_detail_model.dart';
import '../../model/user_data_singleton.dart';

class ImmediateTicketDetailResponse {
  final int statusCode;
  ImmediateTicketDetailModel? data;

  ImmediateTicketDetailResponse({required this.statusCode, this.data});
}

//提取單一立即單-成功
class ImmediateTicketDetailApi {
  static Future<ImmediateTicketDetailResponse> getImmediateTicketDetail(int orderId) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('$baseUrl/app/api/driver/order/detail/$orderId');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        print("hey E : ${response.body}");
        final jsonData = json.decode(response.body);
        final ticketDetail = ImmediateTicketDetailModel.fromJson(jsonData['result']);

        return ImmediateTicketDetailResponse(statusCode: response.statusCode, data: ticketDetail);
      } else {
        print("hey E : Failed to fetch data: ${response.statusCode};; $orderId" );
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print("hey Ei : Failed to fetch data");
      throw Exception('Failed to fetch data: $error');
    }
  }
}