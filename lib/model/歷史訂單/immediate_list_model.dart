class ImmediateListModel {
  final List<Bill> billList;
  final Paging paging;

  ImmediateListModel({
    required this.billList,
    required this.paging,
  });

  factory ImmediateListModel.fromJson(Map<String, dynamic> json) {
    return ImmediateListModel(
      billList: (json['billList'] as List)
          .map((item) => Bill.fromJson(item as Map<String, dynamic>))
          .toList(),
      paging: Paging.fromJson(json['paging']),
    );
  }
}

class Bill {
  final int id;
  final String onLocation;
  final String offLocation;
  final num actualPrice;
  final String orderTime;
  final String finishTime;
  final int orderStatus;
  final String estimatedTime;
  final String passengerNote;
  final String getInTime;
  final String getPassengerTime;
  final List<num>? onGps;
  final List<num>? offGps;
  final dynamic record;

  Bill({
    required this.id,
    required this.onLocation,
    required this.offLocation,
    required this.actualPrice,
    required this.orderTime,
    required this.finishTime,
    required this.orderStatus,
    required this.estimatedTime,
    required this.passengerNote,
    required this.getInTime,
    required this.getPassengerTime,
    required this.onGps,
    required this.offGps,
    required this.record,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? 0,
      onLocation: json['onLocation'] ?? '',
      offLocation: json['offLocation'] ?? '',
      actualPrice: json['actualPrice'] ?? 0,
      orderTime: json['orderTime'] ?? '',
      finishTime: json['finishTime'] ?? '',
      orderStatus: json['orderStatus'] ?? 0,
      estimatedTime: json['estimatedTime'] ?? '',
      passengerNote: json['passengerNote'] ?? '',
      getInTime: json['getInTime'] ?? '',
      getPassengerTime: json['getPassengerTime'] ?? '',
      onGps: (json['onGps'] != null) ? List<num>.from(json['onGps']) : null,
      offGps: (json['offGps'] != null) ? List<num>.from(json['offGps']) : null,
      record: json['record'], // Replace 'dynamic' with the appropriate type
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
      currentPage: json['currentPage'] ?? 0,
      nextPage: json['nextPage'] ?? 0,
      previousPage: json['previousPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      perPage: json['perPage'] ?? 0,
      totalEntries: json['totalEntries'] ?? 0,
    );
  }
}
