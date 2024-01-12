import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String keyUsername = 'username';
  static const String keyPassword = 'password';
  static const String keyTeamCode = 'teamCode';

  // Save user information
  static Future<void> saveUserInformation(String username, String password, String teamCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUsername, username);
    prefs.setString(keyPassword, password);
    prefs.setString(keyTeamCode, teamCode);
  }

  // Retrieve user information
  static Future<Map<String, String>> getUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(keyUsername) ?? '';
    String password = prefs.getString(keyPassword) ?? '';
    String teamCode = prefs.getString(keyTeamCode) ?? '';

    return {'username': username, 'password': password, 'teamCode': teamCode};
  }
}