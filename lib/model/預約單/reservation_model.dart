class ReservationList {
  final String event;
  final bool success;
  final String message;
  final ReservationListResult result;

  ReservationList({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory ReservationList.fromJson(Map<String, dynamic> json) {
    return ReservationList(
      event: json['event'],
      success: json['success'],
      message: json['message'],
      result: ReservationListResult.fromJson(json['result']),
    );
  }
}

class ReservationListResult {
  final List<BillList> billList;
  final Paging paging;

  ReservationListResult({
    required this.billList,
    required this.paging,
  });

  factory ReservationListResult.fromJson(Map<String, dynamic> json) {
    var list = json['billList'] as List;
    List<BillList> billList = list.map((item) => BillList.fromJson(item)).toList();

    return ReservationListResult(
      billList: billList,
      paging: Paging.fromJson(json['paging']),
    );
  }
}

class BillList {
  final PassengerServerInfo passengerServerInfo;
  final BillInfoResevation billInfo;

  BillList({
    required this.passengerServerInfo,
    required this.billInfo,
  });

  factory BillList.fromJson(Map<String, dynamic> json) {
    print("yo yo $json");
    return BillList(
      passengerServerInfo: PassengerServerInfo.fromJson(json['passengerServerInfo'] ?? {}),
      billInfo: BillInfoResevation.fromJson(json['billInfo']),
    );
  }
}

class PassengerServerInfo {
  final String passengerName;
  final String passengerPhone;

  PassengerServerInfo({
    required this.passengerName,
    required this.passengerPhone,
  });

  factory PassengerServerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerServerInfo(
      passengerName: json['passengerName'] ?? '',
      passengerPhone: json['passengerPhone'] ?? '',
    );
  }
}

class BillInfoResevation {
  final dynamic? driverId;
  final int orderStatus;
  final int reservationId;
  final String onLocation;
  final String offLocation;
  final String reservationType;
  final String reservationTime;
  final String passengerNote;
  final List<num> onGps;
  final List<num> offGps;
  final int userNumber;
  final int acknowledgingOrderMethods;
  final String serviceList;
  final String reservationTeam;
  final String blacklist;
  final String createdAt;
  final dynamic clickMeterDate;
  final dynamic getInTime;
  final dynamic getPassengerTime;
  final String passengerOnLocationNote;
  final String isDeal;

  BillInfoResevation({
    required this.driverId,
    required this.orderStatus,
    required this.reservationId,
    required this.onLocation,
    required this.offLocation,
    required this.reservationType,
    required this.reservationTime,
    required this.passengerNote,
    required this.onGps,
    required this.offGps,
    required this.userNumber,
    required this.acknowledgingOrderMethods,
    required this.serviceList,
    required this.reservationTeam,
    required this.blacklist,
    required this.createdAt,
    required this.clickMeterDate,
    required this.getInTime,
    required this.getPassengerTime,
    required this.passengerOnLocationNote,
    required this.isDeal,
  });

  factory BillInfoResevation.fromJson(Map<String, dynamic> json) {
    return BillInfoResevation(
      driverId: json['driverId'] ?? 0,
      orderStatus: json['orderStatus'] ?? 0,
      reservationId: json['reservationId'] ?? 0,
      onLocation: json['onLocation'] ?? '',
      offLocation: json['offLocation'] ?? '',
      reservationType: json['reservationType'] ?? '',
      reservationTime: json['reservationTime'] ?? '',
      passengerNote: json['passengerNote'] ?? '',
      onGps: List<num>.from(json['onGps'] ?? []),
      offGps: List<num>.from(json['offGps'] ?? []),
      userNumber: json['userNumber'],
      acknowledgingOrderMethods: json['acknowledgingOrderMethods'],
      serviceList: json['serviceList'] ?? '',
      reservationTeam: json['reservationTeam'] ?? '',
      blacklist: json['blacklist'] ?? '',
      createdAt: json['createdAt'] ?? '',
      clickMeterDate: json['clickMeterDate'] ?? '',
      getInTime: json['getInTime'] ?? '',
      getPassengerTime: json['getPassengerTime'] ?? '',
      passengerOnLocationNote: json['passengerOnLocationNote'] ?? '',
      isDeal: json['isDeal'] ?? '',
    );
  }
}

class Paging {
  final int currentPage;
  final int nextPage;
  final int previousPage;
  final int totalPages;
  final int perPage;
  final int totalEntries;

  Paging({
    required this.currentPage,
    required this.nextPage,
    required this.previousPage,
    required this.totalPages,
    required this.perPage,
    required this.totalEntries,
  });

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      currentPage: json['currentPage'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      totalPages: json['totalPages'],
      perPage: json['perPage'],
      totalEntries: json['totalEntries'],
    );
  }
}
