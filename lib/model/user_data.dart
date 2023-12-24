// class UserData {
//   final int id;
//   final String teamCode;
//   final String serviceList;
//   final String token;
//   final int type;
//   final int authorize;
//   final List<double> initialGps;
//   final String mongoTable;
//   final int plan;
//   final String callNumber;
//   final String name;
//   final int count;
//   final LoginSetting setting;
//
//   UserData({
//     required this.id,
//     required this.teamCode,
//     required this.serviceList,
//     required this.token,
//     required this.type,
//     required this.authorize,
//     required this.initialGps,
//     required this.mongoTable,
//     required this.plan,
//     required this.callNumber,
//     required this.name,
//     required this.count,
//     required this.setting,
//   });
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['id'],
//       teamCode: json['teamCode'],
//       serviceList: json['serviceList'],
//       token: json['token'],
//       type: json['type'],
//       authorize: json['authorize'],
//       initialGps: List<double>.from(json['initialGps']),
//       mongoTable: json['mongoTable'],
//       plan: json['plan'],
//       callNumber: json['callNumber'],
//       name: json['name'],
//       count: json['count'],
//       setting: LoginSetting.fromJson(json['setting']),
//     );
//   }
// }
//
// class LoginSetting {
//   final List<DefaultMessage> defaultMessage;
//   final int orderLimitTime;
//   final int applyCancelTime;
//   final CalculatedInfo calculatedInfo;
//
//   LoginSetting({
//     required this.defaultMessage,
//     required this.orderLimitTime,
//     required this.applyCancelTime,
//     required this.calculatedInfo,
//   });
//
//   factory LoginSetting.fromJson(Map<String, dynamic> json) {
//     return LoginSetting(
//       defaultMessage: List<DefaultMessage>.from(json['defaultMessage'].map((x) => DefaultMessage.fromJson(x))),
//       orderLimitTime: json['orderLimitTime'],
//       applyCancelTime: json['applyCancelTime'],
//       calculatedInfo: CalculatedInfo.fromJson(json['calculatedInfo']),
//     );
//   }
// }
//
// class DefaultMessage {
//   final String message;
//
//   DefaultMessage({
//     required this.message,
//   });
//
//   factory DefaultMessage.fromJson(Map<String, dynamic> json) {
//     return DefaultMessage(
//       message: json['message'],
//     );
//   }
// }
//
// class CalculatedInfo {
//   final int perKmOfFare;
//   final int perMinOfFare;
//   final int initialFare;
//   final int extraFare;
//   final int lowestFare;
//   final int upKm;
//   final int upPerKmOfFare;
//
//   CalculatedInfo({
//     required this.perKmOfFare,
//     required this.perMinOfFare,
//     required this.initialFare,
//     required this.extraFare,
//     required this.lowestFare,
//     required this.upKm,
//     required this.upPerKmOfFare,
//   });
//
//   factory CalculatedInfo.fromJson(Map<String, dynamic> json) {
//     return CalculatedInfo(
//       perKmOfFare: json['perKmOfFare'],
//       perMinOfFare: json['perMinOfFare'],
//       initialFare: json['initialFare'],
//       extraFare: json['extraFare'],
//       lowestFare: json['lowestFare'],
//       upKm: json['upKm'],
//       upPerKmOfFare: json['upPerKmOfFare'],
//     );
//   }
// }