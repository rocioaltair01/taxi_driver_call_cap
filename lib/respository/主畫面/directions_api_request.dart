import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectionsAPIRequest {
  Future<dynamic> estimateDirections(
      String origin, String destination, String waypoints, String token, bool avoidHighways) async {
    try {
      String avoid = avoidHighways ? "&avoid=highways" : "";
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=$waypoints&language=zh-TW&key=$token$avoid";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode >= 500) {
        return {"error": "Server Error"};
      } else if (response.statusCode >= 400) {
        return {"error": "Directions Calculation Error"};
      } else {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      }
    } catch (e) {
      return {"error": "Failed to estimate directions: $e"};
    }
  }
}
