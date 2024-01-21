import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/user_data_singleton.dart';

class StatisticsResponse {
  final int statusCode;
  final StatisticsResult? data;

  StatisticsResponse({required this.statusCode, this.data});

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) {
    return StatisticsResponse(
      statusCode: json['statusCode'],
      data: json['data'] != null ? StatisticsResult.fromJson(json['data']) : null,
    );
  }
}

class StatisticsApi {
  static Future<StatisticsResponse> getStatistics(
      String year,
      String month,
      Function(String res) onError,
      Function() onNetworkError
      ) async {
    String url = "$baseUrl/app/api/statistics?year=$year&month=$month";
    UserData userData = UserDataSingleton.instance;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-access-token': userData.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final statistics = StatisticsResult.fromJson(jsonData);
        return StatisticsResponse(statusCode: response.statusCode, data: statistics);
      } else {
        onError(response.body);
        throw Exception('Failed to fetch statistics');
      }
    } catch (error) {
      onNetworkError();
      throw Exception('Failed to fetch statistics: $error');
    }
  }
}

class StatisticsResult {
  final String event;
  final bool success;
  final String message;
  final StatisticsData result;

  StatisticsResult({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory StatisticsResult.fromJson(Map<String, dynamic> json) {
    return StatisticsResult(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: StatisticsData.fromJson(json['result']),
    );
  }
}

class StatisticsData {
  final int transactionCount;
  final int transactionSuccessCount;
  final int reservationCount;
  final int reservationSuccessCount;
  final int storeOrderNumber;
  final int storeOrderSuccess;
  final int storeTotalRebate;
  final int revenue;
  final int afterRebate;
  final int monthFare;
  final int afterPayFare;
  final int finalFee;

  StatisticsData({
    required this.transactionCount,
    required this.transactionSuccessCount,
    required this.reservationCount,
    required this.reservationSuccessCount,
    required this.storeOrderNumber,
    required this.storeOrderSuccess,
    required this.storeTotalRebate,
    required this.revenue,
    required this.afterRebate,
    required this.monthFare,
    required this.afterPayFare,
    required this.finalFee,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      transactionCount: json['transactionCount'] ?? 0,
      transactionSuccessCount: json['transactionSuccessCount'] ?? 0,
      reservationCount: json['reservationCount'] ?? 0,
      reservationSuccessCount: json['reservationSuccessCount'] ?? 0,
      storeOrderNumber: json['storeOrderNumber'] ?? 0,
      storeOrderSuccess: json['storeOrderSuccess'] ?? 0,
      storeTotalRebate: json['storeTotalRebate'] ?? 0,
      revenue: json['revenue'] ?? 0,
      afterRebate: json['afterRebate'] ?? 0,
      monthFare: json['monthFare'] ?? 0,
      afterPayFare: json['afterPayFare'] ?? 0,
      finalFee: json['finalFee'] ?? 0,
    );
  }
}
