import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../model/user_data_singleton.dart';

class DriverInformationResponse {
  final int statusCode;
  final DriverInformation? data;

  DriverInformationResponse({required this.statusCode, this.data});

  factory DriverInformationResponse.fromJson(Map<String, dynamic> json) {
    return DriverInformationResponse(
      statusCode: json['statusCode'],
      data: json['data'] != null ? DriverInformation.fromJson(json['data']) : null,
    );
  }
}

class DriverInformationApi {
  static Future<DriverInformationResponse> getDriverInformation(
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    final Uri uri = Uri.parse('$baseUrl/app/api/driver/info');

    UserData userData = UserDataSingleton.instance;
    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': userData.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final driverInfo = DriverInformation.fromJson(jsonData);

        return DriverInformationResponse(statusCode: response.statusCode, data: driverInfo);
      } else {
        onError(response.body);
        throw Exception('Failed to fetch driver information');
      }
    } catch (error) {
      onNetworkError();
      throw Exception('Failed to fetch driver information: $error');
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
