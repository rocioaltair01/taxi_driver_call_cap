
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/客服/announcement_model.dart';
import '../../model/user_data_singleton.dart';

class AnnounceApi {
  static Future<AnnounceList> getAnnouncement() async {
    UserData loginResult = UserDataSingleton.instance;
    final Uri uri = Uri.parse(
        '$baseUrl/app/api/driver/announce?per_page=10&current_page=1');
    try {
      final response = await http.get(
        uri,
        headers: {
          'x-access-token': loginResult.token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("hey jsonData $jsonData");
        final AnnounceList reservationData = AnnounceList.fromJson(jsonData);

        return reservationData;
      } else {
        throw Exception('Failed1 to fetch data');
      }
    } catch (error) {
      throw Exception('Failed1 to fetch data: $error');
    }
  }
}