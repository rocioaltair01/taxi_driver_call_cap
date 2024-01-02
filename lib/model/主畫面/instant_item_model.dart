class InstantItemModel {
  final int orderId;
  final String onLocation;
  final String? note;
  final String? offLocation;
  final double distance;
  final int time;

  InstantItemModel({
    required this.orderId,
    required this.onLocation,
    this.note,
    this.offLocation,
    required this.distance,
    required this.time,
  });

  factory InstantItemModel.fromJson(Map<String, dynamic> json) {
    return InstantItemModel(
      orderId: json['orderId'],
      onLocation: json['onLocation'],
      note: json['note'],
      offLocation: json['offLocation'],
      distance: json['distance'],
      time: json['time'],
    );
  }
}
