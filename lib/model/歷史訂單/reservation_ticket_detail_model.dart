class ReservationTicketDetailModel {
  final String event;
  final bool success;
  final String message;
  final PassengerInfo passengerInfo;
  final BillInfo billInfo;

  ReservationTicketDetailModel({
    required this.event,
    required this.success,
    required this.message,
    required this.passengerInfo,
    required this.billInfo,
  });

  factory ReservationTicketDetailModel.fromJson(Map<String, dynamic> json) {
    return ReservationTicketDetailModel(
      event: json['event'] ?? '',
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      passengerInfo: PassengerInfo.fromJson(json['result']['passengerInfo'] ?? {}),
      billInfo: BillInfo.fromJson(json['result']['billInfo'] ?? {}),
    );
  }
}

class PassengerInfo {
  final int? passengeID;
  final String? passengerName;

  PassengerInfo({
    required this.passengeID,
    required this.passengerName,
  });

  factory PassengerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerInfo(
      passengeID: json['passengeID'],
      passengerName: json['passengerName'],
    );
  }
}

class BillInfo {
  final int? actualPrice;
  final int? orderStatus;
  final int? orderId;
  final List<num>? onGps;
  final List<num>? offGps;
  final String? onLocation;
  final String? offLocation;
  final String? reservationType;
  final String? finishTime;
  final String? passengerOnLocationNote;
  final String? passengerNote;
  final String? passengerCancel;
  final String? driverCancel;
  final int? result;
  final String? passengerName;
  final int? userNumber;
  final String? serviceList;
  // final int? acknowledgingOrderMethods;
  final String? reservationTeam;
  final String? reservationTime;
  final int? cars;
  // final int? grabbedCars;
  final String? blacklist;
  final int? milage;
  final int? routeSecond;

  BillInfo({
    required this.actualPrice,
    required this.orderStatus,
    required this.orderId,
    required this.onGps,
    required this.offGps,
    required this.onLocation,
    required this.offLocation,
    required this.reservationType,
    required this.finishTime,
    required this.passengerOnLocationNote,
    required this.passengerNote,
    required this.passengerCancel,
    required this.driverCancel,
    required this.result,
    required this.passengerName,
    required this.userNumber,
    required this.serviceList,
    /// required this.acknowledgingOrderMethods,
    required this.reservationTeam,
    required this.reservationTime,
    required this.cars,
    // required this.grabbedCars,
    required this.blacklist,
    required this.milage,
    required this.routeSecond,
  });

  factory BillInfo.fromJson(Map<String, dynamic> json) {
    return BillInfo(
      actualPrice: json['actualPrice'],
      orderStatus: json['orderStatus'],
      orderId: json['orderId'],
      onGps: json['onGps'] != null ? List<int>.from(json['onGps']) : null,
      offGps: json['offGps'] != null ? List<int>.from(json['offGps']) : null,
      onLocation: json['onLocation'],
      offLocation: json['offLocation'],
      reservationType: json['reservationType'],
      finishTime: json['finishTime'],
      passengerOnLocationNote: json['passengerOnLocationNote'],
      passengerNote: json['passengerNote'],
      passengerCancel: json['passengerCancel'],
      driverCancel: json['driverCancel'],
      result: json['result'],
      passengerName: json['passengerName'],
      userNumber: json['userNumber'],
      serviceList: json['serviceList'],
      //acknowledgingOrderMethods: json['acknowledgingOrderMethods'],
      reservationTeam: json['reservationTeam'],
      reservationTime: json['reservationTime'],
      cars: json['cars'],
      //   grabbedCars: json['grabbedCars'],
      blacklist: json['blacklist'],
      milage: json['milage'],
      routeSecond: json['routeSecond'],
    );
  }
}
