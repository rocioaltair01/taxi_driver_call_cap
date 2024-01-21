import 'package:dio/dio.dart';

import '../constants/constants.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<void> triggerDriverGps(
      double latitude,
      double longitude,
      int plan,
      int status,
      int taxiSort,
      String token,
      ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/app/api/driver/gps',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'x-access-token': token,
          },
        ),
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'plan': plan,
          'status': status,
          'taxiSort': taxiSort,
        },
      );
      if (response.statusCode! >= 500) {
        throw Exception('更新司機Gps，伺服器發生錯誤，${response.data}');
      } else if (response.statusCode! >= 400) {
        throw Exception('更新司機Gps發生錯誤，狀態碼:${response.statusCode}，錯誤訊息:${response.data}');
        // You can implement your logic for checking token expiration here
      } else {
        //print('更新司機GpsResponse code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('更新司機Gps失敗，$error');
    }
  }
}
