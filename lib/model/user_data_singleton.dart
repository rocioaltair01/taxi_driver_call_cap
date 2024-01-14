
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'login_response_model.dart';

class UserDataSingleton {
  static UserData? _instance;

  static UserData get instance {
    if (_instance == null) {
      throw Exception("LoginResult has not been initialized");
    }
    return _instance!;
  }

  static bool get hasInstance => _instance != null;

  static void initialize(UserData loginResult) {
    // 如果 _instance 为空，设置它
    if (_instance == null) {
      _instance = loginResult;
    } else {
      throw Exception("LoginResult has already been initialized");
    }
  }

  static void reset() {
    // 重置 _instance 为 null，使其可重新初始化
    _instance = null;
  }
}

class LoginResponseModel {
  final String event;
  final bool success;
  final String message;
  final UserData result;

  LoginResponseModel({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: UserData.fromJson(json['result']),
    );
  }
}

class UserData {
  final int id;
  final String teamCode;
  final String serviceList;
  final String token;
  final int type;
  final int authorize;
  final List<double> initialGps;
  final String mongoTable;
  final int plan;
  final String callNumber;
  final String name;
  final int count;
  final LoginSetting setting;
  String _phoneNumber;
  String _password;
  LatLng _currentLocation;

  UserData({
    required this.id,
    required this.teamCode,
    required this.serviceList,
    required this.token,
    required this.type,
    required this.authorize,
    required this.initialGps,
    required this.mongoTable,
    required this.plan,
    required this.callNumber,
    required this.name,
    required this.count,
    required this.setting,
    required String phoneNumber,
    required String password,
    required LatLng currentLocation
  }):_phoneNumber = phoneNumber, _password = password, _currentLocation = currentLocation;

  // Getter for phoneNumber
  String get phoneNumber => _phoneNumber;
  String get password => _password;
  LatLng get currentLocation => _currentLocation;

  // Method to update phoneNumber
  UserData updatePhoneNumber(String newPhoneNumber) {
    return UserData(
      id: this.id,
      teamCode: this.teamCode,
      serviceList: this.serviceList,
      token: this.token,
      type: this.type,
      authorize: this.authorize,
      initialGps: this.initialGps,
      mongoTable: this.mongoTable,
      plan: this.plan,
      callNumber: this.callNumber,
      name: this.name,
      count: this.count,
      setting: this.setting,
      phoneNumber: newPhoneNumber,
      password: this.password,
      currentLocation: currentLocation
    );
  }

  UserData updatePassword(String newPassword) {
    return UserData(
        id: this.id,
        teamCode: this.teamCode,
        serviceList: this.serviceList,
        token: this.token,
        type: this.type,
        authorize: this.authorize,
        initialGps: this.initialGps,
        mongoTable: this.mongoTable,
        plan: this.plan,
        callNumber: this.callNumber,
        name: this.name,
        count: this.count,
        setting: this.setting,
        phoneNumber: this.phoneNumber,
        password: newPassword,
        currentLocation: currentLocation
    );
  }

  UserData updateLocation(LatLng newLocation) {
    return UserData(
        id: this.id,
        teamCode: this.teamCode,
        serviceList: this.serviceList,
        token: this.token,
        type: this.type,
        authorize: this.authorize,
        initialGps: this.initialGps,
        mongoTable: this.mongoTable,
        plan: this.plan,
        callNumber: this.callNumber,
        name: this.name,
        count: this.count,
        setting: this.setting,
        phoneNumber: this.phoneNumber,
        password: this.password,
        currentLocation: newLocation
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      teamCode: json['teamCode'],
      serviceList: json['serviceList'],
      token: json['token'],
      type: json['type'],
      authorize: json['authorize'],
      initialGps: List<double>.from(json['initialGps']),
      mongoTable: json['mongoTable'],
      plan: json['plan'],
      callNumber: json['callNumber'],
      name: json['name'],
      count: json['count'],
      setting: LoginSetting.fromJson(json['setting']),
      phoneNumber: (json['phoneNumber'] == null) ? '' : json['phoneNumber'],
      password: (json['password'] == null) ? '' : json['password'],
      currentLocation: (json['currentLocation'] == null) ? LatLng(0, 0) : json['currentLocation'],
    );
  }
}

class LoginSetting {
  final List<DefaultMessage> defaultMessage;
  final int orderLimitTime;
  final int applyCancelTime;
  final CalculatedInfo calculatedInfo;

  LoginSetting({
    required this.defaultMessage,
    required this.orderLimitTime,
    required this.applyCancelTime,
    required this.calculatedInfo,
  });

  factory LoginSetting.fromJson(Map<String, dynamic> json) {
    return LoginSetting(
      defaultMessage: List<DefaultMessage>.from(json['defaultMessage'].map((x) => DefaultMessage.fromJson(x))),
      orderLimitTime: json['orderLimitTime'],
      applyCancelTime: json['applyCancelTime'],
      calculatedInfo: CalculatedInfo.fromJson(json['calculatedInfo']),
    );
  }
}

class DefaultMessage {
  final String message;

  DefaultMessage({
    required this.message,
  });

  factory DefaultMessage.fromJson(Map<String, dynamic> json) {
    return DefaultMessage(
      message: json['message'],
    );
  }
}

class CalculatedInfo {
  final int perKmOfFare;
  final int perMinOfFare;
  final int initialFare;
  final int extraFare;
  final int lowestFare;
  final int upKm;
  final int upPerKmOfFare;

  CalculatedInfo({
    required this.perKmOfFare,
    required this.perMinOfFare,
    required this.initialFare,
    required this.extraFare,
    required this.lowestFare,
    required this.upKm,
    required this.upPerKmOfFare,
  });

  factory CalculatedInfo.fromJson(Map<String, dynamic> json) {
    print("CalculatedInfo $json");
    return CalculatedInfo(
      perKmOfFare: json['perKmOfFare'],
      perMinOfFare: json['perMinOfFare'],
      initialFare: json['initialFare'],
      extraFare: json['extraFare'],
      lowestFare: json['lowestFare'],
      upKm: json['upKm'],
      upPerKmOfFare: json['upPerKmOfFare'],
    );
  }
}
