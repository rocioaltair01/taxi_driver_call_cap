import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class ArrivedSuccessApiResponse {
  final String event;
  final bool success;
  final String message;
  final bool result;

  ArrivedSuccessApiResponse({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory ArrivedSuccessApiResponse.fromJson(Map<String, dynamic> json) {
    return ArrivedSuccessApiResponse(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: json['result'],
    );
  }
}

// 更新到達時間
class ArrivedSuccessApi {
  Future<ArrivedSuccessApiResponse> markArrivalSuccess(
      int orderId,
      int orderType,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    UserData loginResult = UserDataSingleton.instance;
    print("orderId$orderType");
    try {
      String url = '$baseUrl/app/api/others/get_in_time/$orderId/?order_state=1&order_type=$orderType';

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return ArrivedSuccessApiResponse.fromJson(decodedResponse);
      } else {
        onError(response.body);
        throw Exception('Failed to mark arrival success ${response.statusCode}');
      }
    } catch (e) {
      print("@=== Failed markArrivalSuccess e $e");
      onNetworkError();
      throw Exception('Failed to mark arrival success');
    }
  }
}
