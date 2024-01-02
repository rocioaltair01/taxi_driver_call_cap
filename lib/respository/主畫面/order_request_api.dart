import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user_data_singleton.dart';
import '../../model/主畫面/instant_item_model.dart';

class OrderRequestAboveResponse {
  final int statusCode;
  List<InstantItemModel>? data;

  OrderRequestAboveResponse({required this.statusCode, this.data});
}

class OrderRequestAboveApi {
  static Future<OrderRequestAboveResponse> getOrderRequestAbove(double lat, double lng) async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse('https://test-fleet-of-taxi.shopinn.tw/api/order-info?lat=$lat&lng=$lng&orderIdsToExclude=0&orderIdsToExclude=0');

    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        print("Order Request:: Above Response: ${response.body}");
        final jsonData = json.decode(response.body);

        List<InstantItemModel> items = (jsonData['result'] as List)
            .map((item) => InstantItemModel.fromJson(item))
            .toList();

        return OrderRequestAboveResponse(statusCode: response.statusCode, data: items);
      } else {
        print("Order Request:: Above Failed: Failed to fetch data${response.statusCode}");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print("Order Request:: Above Error: Failed to fetch data: $error");
      throw Exception('Failed to fetch data: $error');
    }
  }
}