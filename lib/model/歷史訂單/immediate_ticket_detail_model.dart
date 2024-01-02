class ImmediateTicketDetailModel {
  final int? id;
  final String? onLocation;
  final String? offLocation;
  final int? actualPrice;
  final String? passengerPhone;
  final dynamic driverCancel;
  final dynamic passengerCancel;
  final String? passengerNote;
  final int? payMethod;
  final List<num>? onGps;
  final List<num>? offGps;
  final dynamic signingId;
  final int? milage;
  final DateTime? orderTime;
  final DateTime? finishTime;
  final int? routeSecond;
  final int? userNumber;
  final int? orderStatus;

  ImmediateTicketDetailModel({
    this.id,
    this.onLocation,
    this.offLocation,
    this.actualPrice,
    this.passengerPhone,
    this.driverCancel,
    this.passengerCancel,
    this.passengerNote,
    this.payMethod,
    this.onGps,
    this.offGps,
    this.milage,
    this.signingId,
    this.orderTime,
    this.finishTime,
    this.routeSecond,
    this.userNumber,
    this.orderStatus,
  });

  factory ImmediateTicketDetailModel.fromJson(Map<String, dynamic> json) {
    return ImmediateTicketDetailModel(
      id: json['id'],
      onLocation: json['onLocation'],
      offLocation: json['offLocation'],
      actualPrice: json['actualPrice'],
      passengerPhone: json['passengerPhone'],
      driverCancel: json['driverCancel'],
      passengerCancel: json['passengerCancel'],
      passengerNote: json['passengerNote'],
      payMethod: json['payMethod'],
      onGps: json['onGps'] != null ? List<num>.from(json['onGps']) : null,
      offGps: json['offGps'] != null ? List<num>.from(json['offGps']) : null,
      milage: json['milage'] != null ? json['milage'] : 0,
      signingId: json['signingId'],
      orderTime: json['orderTime'] != null ? DateTime.parse(json['orderTime']) : null,
      finishTime: json['finishTime'] != null ? DateTime.parse(json['finishTime']) : null,
      routeSecond: json['routeSecond'],
      userNumber: json['userNumber'],
      orderStatus: json['orderStatus'],
    );
  }
}
