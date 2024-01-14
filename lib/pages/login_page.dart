import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/shared_user_preference.dart';
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
    return const LoginPage();
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _teamCodeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login(
      BuildContext context,
      String username,
      String password,
      String teamCode
      ) async {
    // String username = _usernameController.text;
    // String password = _passwordController.text;
    // String teamCode = _teamCodeController.text;
    String firebaseToken = '123'; // Replace with actual firebase token

    if (username.isEmpty) {
      DialogUtils.showErrorDialog("錯誤", "請輸入帳號",context);
      return;
    }
    if (password.isEmpty) {
      DialogUtils.showErrorDialog("錯誤", "請輸入密碼",context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> loginData = await LoginApi.login(username, password, teamCode, firebaseToken);
      LoginResponseModel responseModel = LoginResponseModel.fromJson(loginData);
      UserData userData = responseModel.result;
      userData = userData.updatePhoneNumber(username);
      userData = userData.updatePassword(password);
      UserDataSingleton.initialize(userData);
      // Save user information after initializing UserDataSingleton
      await UserPreferences.saveUserInformation(username, password, teamCode);
      NavigationService().routeTo('/TabbarPage', arguments: 'just a test');
    } catch (error) {
      print('Login failed: $error');
      DialogUtils.showErrorDialog("錯誤", "該司機帳號並未註冊或密碼錯誤",context);
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ?
      const Center(
        child: SpinKitFadingCircle(
          color: Colors.black,
          size: 80.0,
        )
      )
    : Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(
                child: Text(
                  "即時派遣",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
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
                        "車隊編號",
                        style:
                        TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _teamCodeController,
                      decoration: const InputDecoration(
                        labelText: '請輸入車隊編號',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          fontSize: 18,
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
            bottom: 50,
            left: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () => _login(
                  context,
                  _usernameController.text,
                  _passwordController.text,
                  _teamCodeController.text,
                  // "0912345678",
                  // "123456",
                  // "002"
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "登入",
                  style:
                  TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      );
  }
}



