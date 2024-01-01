import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/user_data_singleton.dart';
import '../respository/login_api.dart';
import '../respository/navigation_service.dart';
import '../util/dialog_util.dart';



void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // print("loginNavigatorKey1${widget.currentState}");
    return const Scaffold(
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
 // final GlobalKey<NavigatorState> navigatorKey;

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {

  LoginForm({Key? key,}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  Future<void> _login(BuildContext context) async {
    // String username = _usernameController.text;
    // String password = _passwordController.text;
   String username = '0912345678';
   String password = '123456';
    String teamCode = '002';
    String firebaseToken = '123'; // Replace with actual firebase token

    if (username.isEmpty) {
      DialogUtils.showErrorDialog("錯誤", "請輸入帳號",context);
      return;
    }
    if (password.isEmpty) {
      DialogUtils.showErrorDialog("錯誤", "請輸入密碼",context);
      return;
    }

    try {
      Map<String, dynamic> loginData = await LoginApi.login(username, password, teamCode, firebaseToken);
      LoginResponseModel responseModel = LoginResponseModel.fromJson(loginData);
      UserData userData = responseModel.result;
      userData = userData.updatePhoneNumber(username);
      UserDataSingleton.initialize(userData);

      NavigationService().routeTo('/TabbarPage', arguments: 'just a test');

    } catch (error) {
      print('Login failed: $error');
      DialogUtils.showErrorDialog("錯誤", "該司機帳號並未註冊或密碼錯誤",context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(child:
              Text(
                "即時派遣",
                style: TextStyle(
                  color: Colors.grey, // Set the text color to gray
                  fontSize: 30, // Set the font size to 40
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "帳號",
                      style:
                      TextStyle(
                        fontSize: 18, // Set the font size to 40
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '請輸入電話號碼',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "密碼",
                      style:
                      TextStyle(
                        fontSize: 18, // Set the font size to 40
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '請輸入密碼',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () => _login(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "登入",
                style:
                TextStyle(
                  fontSize: 18, // Set the font size to 40
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
