import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class UpdatePass5ApiResponse {
  final bool success;
  final String message;
  final Result result;

  UpdatePass5ApiResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory UpdatePass5ApiResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePass5ApiResponse(
      success: json['success'],
      message: json['message'],
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final int id;
  final String onLocation;

  Result({
    required this.id,
    required this.onLocation,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      onLocation: json['on_location'],
    );
  }
}

class UpdatePass5Api {
  Future<UpdatePass5ApiResponse> updatePass5Api() async {
    UserData loginResult = UserDataSingleton.instance;
    try {
      final url = Uri.parse('$baseUrl/app/api/others/meter_date/16354/?order_state=0&order_type=1');
      final response = await http.put(
        url,
        headers: {
          'x-access-token': loginResult.token,
        },
        body: jsonEncode({
          'event': 'putClickMeterDate',
          'success': true,
          'message': '紀錄過五跳表時間成功',
          'result': {
            'id': 16354,
            'on_location': '台中',
          },
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return UpdatePass5ApiResponse.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to update pass 5 API');
      }
    } catch (e) {
      return UpdatePass5ApiResponse(
        success: false,
        message: 'Failed to update pass 5 API: $e',
        result: Result(id: 0, onLocation: ''),
      );
    }
  }
}
