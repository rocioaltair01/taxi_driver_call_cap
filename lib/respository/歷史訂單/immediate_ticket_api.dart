import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';
import '../../model/歷史訂單/immediate_list_model.dart';

class ImmediateTicketResponse {
  final int statusCode;
  List<Bill> data;

  ImmediateTicketResponse({required this.statusCode, required this.data});
}

class ImmediateTicketApi {
  static Future<ImmediateTicketResponse> getImmediateTickets(
      int year,
      int month,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/v2/driver/order?year=${year.toString()}&month=${month.toString()}&per_page=10&current_page=1');
    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final ImmediateListModel reservationData = ImmediateListModel.fromJson(jsonData['result']);
        return ImmediateTicketResponse(statusCode: response.statusCode, data: reservationData.billList);
      } else {
        onError(response.body);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      onNetworkError();
      throw Exception('Failed to fetch data: $error');
    }
  }
}
