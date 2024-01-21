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
  static Future<ImmediateTicketDetailResponse> getImmediateTicketDetail(
      int orderId,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
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
        final jsonData = json.decode(response.body);
        final ticketDetail = ImmediateTicketDetailModel.fromJson(jsonData['result']);

        return ImmediateTicketDetailResponse(statusCode: response.statusCode, data: ticketDetail);
      } else {
        print("@=== Failed to fetch ImmediateTicketDetailApi: ${response.statusCode} $orderId" );
        onError(response.body);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      onNetworkError();
      print("@=== Failed to fetch ImmediateTicketDetailApi $error");
      throw Exception('Failed to fetch ImmediateTicketDetailApi: $error');
    }
  }
}