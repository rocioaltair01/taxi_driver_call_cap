import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/shared_user_preference.dart';
import '../model/error_res_model.dart';
import '../model/user_data_singleton.dart';
import '../respository/login_api.dart';
import '../navigation_service.dart';
import '../respository/主畫面/driver_auth_api.dart';
import '../util/dialog_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkUserPreferences();
  }

  Future<void> checkUserPreferences() async {
    Map<String, String>? userInformation = await UserPreferences.getUserInformation();

    if (userInformation == null) {
      print('@=== UserPreferences is null or user information retrieval failed.');
    } else if (!(userInformation['username'] == '' &&
        userInformation['password'] == '' &&
        userInformation['teamCode'] == ''
    )) {
      print("@=== 自動登入: ${userInformation['username']} ${userInformation['password']} ${userInformation['teamCode']}");
      _login(context,
          userInformation['username']!,
          userInformation['password']!,
          userInformation['teamCode']!
      );
      navigateMainPage();
      setState(() {
        isLoading = false;
      });
    } else {
      navigateToLoginPage();
    }
  }

  void navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 3));
    NavigationService().routeTo('/LoginPage', arguments: 'just a test');
  }

  void navigateMainPage() async {
    await Future.delayed(const Duration(seconds: 3));
    NavigationService().routeTo('/LoginPage', arguments: 'just a test');
    NavigationService().routeTo('/TabbarPage', arguments: 'just a test');
  }

  Future<void> _login(
      BuildContext context,
      String username,
      String password,
      String teamCode
      ) async {
    setState(() {
      isLoading = true;
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? firebaseToken = await messaging.getAPNSToken();
    print('@=== FCM Token firebaseToken: $firebaseToken');

    try {
      Map<String, dynamic> loginData = await LoginApi.login(
          username,
          password,
          teamCode,
          firebaseToken ?? "123",
          (res) {
            final jsonData = json.decode(res) as Map<String, dynamic>;
            ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
            GlobalDialog.showAlertDialog(
                context,
                "錯誤",
                responseModel.message
            );
          },
          () {
            GlobalDialog.showAlertDialog(context, "錯誤", "網路異常");
          }
      );
      LoginResponseModel responseModel = LoginResponseModel.fromJson(loginData);
      UserData userData = responseModel.result;

      DriverAuthResponse auth = await DriverAuthApi.getDriverAuth(
          userData.token,
          (res) {
            final jsonData = json.decode(res) as Map<String, dynamic>;
            ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
            GlobalDialog.showAlertDialog(
                context,
                "錯誤",
                responseModel.message
            );
          },
          () {
            GlobalDialog.showAlertDialog(context, "錯誤", "網路異常");
          }
      );
      userData = userData.updateAuth(auth.result.authorize);
      userData = userData.updatePhoneNumber(username);
      UserDataSingleton.initialize(userData);

      await UserPreferences.saveUserInformation(username, password, teamCode);
    } catch (error) {
      print('@=== Login failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? const Center(child: SpinKitFadingCircle(
        color: Colors.black,
        size: 80.0,
      ),) : Center(
        child:Image.asset(
            height: 200,
            width: 200,
            'assets/images/launch.png'
        ),
      )
    );
  }
}
