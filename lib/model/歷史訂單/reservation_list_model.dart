class ReservationListModel {
  final List<ReservationInfo> billList;
  final Paging paging;

  ReservationListModel({
    required this.billList,
    required this.paging,
  });

  factory ReservationListModel.fromJson(Map<String, dynamic> json) {
    return ReservationListModel(
      billList: List<ReservationInfo>.from(json['billList'].map((x) => ReservationInfo.fromJson(x))),
      paging: Paging.fromJson(json['paging']),
    );
  }
}

class ReservationInfo {
  final PassengerServerInfo? passengerServerInfo;
  final BillInfo billInfo;

  ReservationInfo({
    this.passengerServerInfo,
    required this.billInfo,
  });

  factory ReservationInfo.fromJson(Map<String, dynamic> json) {
    return ReservationInfo(
      passengerServerInfo : json['passengerServerInfo'] != null ? PassengerServerInfo.fromJson(json['passengerServerInfo']) : null,
      billInfo: BillInfo.fromJson(json['billInfo']),
    );
  }
}

class PassengerServerInfo {
  final String? passengerName;
  final String? passengerPhone;

  PassengerServerInfo({
    this.passengerName,
    this.passengerPhone,
  });

  factory PassengerServerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerServerInfo(
      passengerName: json['passengerName'] ?? '',
      passengerPhone: json['passengerPhone'] ?? '',
    );
  }
}

class BillInfo {
  final int? orderStatus;
  final int? reservationId;
  final String? onLocation;
  final String? offLocation;
  final String? reservationType;
  final String? reservationTime;
  final String? passengerNote;
  final List<double>? onGps;
  final List<double>? offGps;
  final int? userNumber;
  final int? acknowledgingOrderMethods;
  final String? serviceList;
  final String? reservationTeam;
  final String? blacklist;
  final String? createdAt;
  final dynamic? clickMeterDate;
  final String? getInTime;
  final String? getPassengerTime;
  final String? passengerOnLocationNote;
  final int? actualPrice;
  final int? milage;
  final int? routeSecond;
  final dynamic? record;

  BillInfo({
    this.orderStatus,
    this.reservationId,
    this.onLocation,
    this.offLocation,
    this.reservationType,
    this.reservationTime,
    this.passengerNote,
    this.onGps,
    this.offGps,
    this.userNumber,
    this.acknowledgingOrderMethods,
    this.serviceList,
    this.reservationTeam,
    this.blacklist,
    this.createdAt,
    this.clickMeterDate,
    this.getInTime,
    this.getPassengerTime,
    this.passengerOnLocationNote,
    this.actualPrice,
    this.milage,
    this.routeSecond,
    this.record,
  });

  factory BillInfo.fromJson(Map<String, dynamic> json) {
    dynamic gpsData = json['onGps'];
    List<double>? convertedGps;

    if (gpsData != null) {
      if (gpsData is List<int>) {
        convertedGps = gpsData.map((value) => value.toDouble()).toList();
      } else if (gpsData is List<double>) {
        convertedGps = gpsData;
      }
    }

    dynamic offGpsData = json['onGps'];
    List<double>? convertedOffGps;

    if (offGpsData != null) {
      if (offGpsData is List<int>) {
        convertedOffGps = offGpsData.map((value) => value.toDouble()).toList();
      } else if (offGpsData is List<double>) {
        convertedOffGps = offGpsData;
      }
    }

    return BillInfo(
      orderStatus: json['orderStatus'] as int?,
      reservationId: json['reservationId'] as int?,
      onLocation: json['onLocation'] as String?,
      offLocation: json['offLocation'] as String?,
      reservationType: json['reservationType'] as String?,
      reservationTime: json['reservationTime'] as String?,
      passengerNote: json['passengerNote'] as String?,
      onGps: convertedGps,
      offGps: convertedOffGps,
      userNumber: json['userNumber'] as int?,
      acknowledgingOrderMethods: json['acknowledgingOrderMethods'] as int?,
      serviceList: json['serviceList'] as String?,
      reservationTeam: json['reservationTeam'] as String?,
      blacklist: json['blacklist'] as String?,
      createdAt: json['createdAt'] as String?,
      clickMeterDate: json['clickMeterDate'],
      getInTime: json['getInTime'] as String?,
      getPassengerTime: json['getPassengerTime'] as String?,
      passengerOnLocationNote: json['passengerOnLocationNote'] as String?,
      actualPrice: json['actualPrice'] as int?,
      milage: json['milage'] as int?,
      routeSecond: json['routeSecond'] as int?,
      record: json['record'],
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
