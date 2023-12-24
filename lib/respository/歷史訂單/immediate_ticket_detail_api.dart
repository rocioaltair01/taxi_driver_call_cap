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
        print("hey E : Failed to fetch data");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print("hey Ei : Failed to fetch data");
      throw Exception('Failed to fetch data: $error');
    }
  }
}


class DriverInformation {
  final String event;
  final bool success;
  final String message;
  final DriverInfoResult result;

  DriverInformation({required this.event, required this.success, required this.message, required this.result});

  factory DriverInformation.fromJson(Map<String, dynamic> json) {
    return DriverInformation(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: DriverInfoResult.fromJson(json['result']),
    );
  }
}

class DriverInfoResult {
  final String driverName;
  final String teamName;
  final String callNumber;
  final int reputation;
  final String shot;
  final List<String> driverInfoPhoto;
  final String serviceList;
  final String serviceName;
  final String plateNumber;

  DriverInfoResult({
    required this.driverName,
    required this.teamName,
    required this.callNumber,
    required this.reputation,
    required this.shot,
    required this.driverInfoPhoto,
    required this.serviceList,
    required this.serviceName,
    required this.plateNumber,
  });

  factory DriverInfoResult.fromJson(Map<String, dynamic> json) {
    return DriverInfoResult(
      driverName: json['driverName'],
      teamName: json['teamName'],
      callNumber: json['callNumber'],
      reputation: json['reputation'],
      shot: json['shot'],
      driverInfoPhoto: List<String>.from(json['driverInfoPhoto']),
      serviceList: json['serviceList'],
      serviceName: json['serviceName'],
      plateNumber: json['plateNumber'],
    );
  }
}