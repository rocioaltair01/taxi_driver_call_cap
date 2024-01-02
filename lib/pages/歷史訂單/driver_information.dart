// class DriverInformation {
//   final String event;
//   final bool success;
//   final String message;
//   final DriverInfoResult result;
//
//   DriverInformation({required this.event, required this.success, required this.message, required this.result});
//
//   factory DriverInformation.fromJson(Map<String, dynamic> json) {
//     return DriverInformation(
//       event: json['event'],
//       success: json['success'],
//       message: json['message'],
//       result: DriverInfoResult.fromJson(json['result']),
//     );
//   }
// }
//
// class DriverInfoResult {
//   final String driverName;
//   final String teamName;
//   final String callNumber;
//   final int reputation;
//   final String shot;
//   final List<String> driverInfoPhoto;
//   final String serviceList;
//   final String serviceName;
//   final String plateNumber;
//
//   DriverInfoResult({
//     required this.driverName,
//     required this.teamName,
//     required this.callNumber,
//     required this.reputation,
//     required this.shot,
//     required this.driverInfoPhoto,
//     required this.serviceList,
//     required this.serviceName,
//     required this.plateNumber,
//   });
//
//   factory DriverInfoResult.fromJson(Map<String, dynamic> json) {
//     return DriverInfoResult(
//       driverName: json['driverName'],
//       teamName: json['teamName'],
//       callNumber: json['callNumber'],
//       reputation: json['reputation'],
//       shot: json['shot'],
//       driverInfoPhoto: List<String>.from(json['driverInfoPhoto']),
//       serviceList: json['serviceList'],
//       serviceName: json['serviceName'],
//       plateNumber: json['plateNumber'],
//     );
//   }
// }