import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../model/user_data_singleton.dart';
import '../../../respository/主畫面/create_ticket_history_price_api.dart';
import '../../../util/dialog_util.dart';
import '../../../util/shared_util.dart';
import '../main_page.dart';

class OfflineCountPricePage extends StatefulWidget {
  const OfflineCountPricePage({super.key});

  @override
  State<OfflineCountPricePage> createState() => _OfflineCountPricePageState();
}

class _OfflineCountPricePageState extends State<OfflineCountPricePage> {
  double price = 100;
  double duration = 0;
  double distance = 0;
  LatLng? _currentPosition;
  Timer? distanceTimer;
  Timer? timeTimer;

  @override
  void initState() {
    super.initState();
    getLocation();
    startTimer();
  }

  @override
  void dispose() {
    distanceTimer?.cancel();
    timeTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    distanceTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      calculateDistance();
    });
    timeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      duration = duration + 1;
    });
  }

  void calculateDistance() async {
    if (_currentPosition != null) {
      // Fetch the user's current location
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Calculate the distance between the current and new positions
      double newDistance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // Update the distance and current position
      setState(() {
        distance += newDistance/1000;
        _currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
      });
    }
  }

  getLocation() async {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      //_isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container()),
              Text(
                "跳表金額: $price 元",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                "分鐘數: ${double.parse((duration/60).toStringAsFixed(1))} 分",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                "里程數: ${distance.toStringAsFixed(1)} 公里",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                              },
                              child: const Text(
                                '估算金額',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(width: 30,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),

                              onPressed: () async {
                                CalculatedInfo calculateInfo = UserDataSingleton.instance.setting.calculatedInfo;
                                double totalPrice = calculateTotalCost(
                                    calculateInfo.perKmOfFare,
                                    calculateInfo.perMinOfFare,
                                    calculateInfo.initialFare,
                                    calculateInfo.upPerKmOfFare,
                                    calculateInfo.extraFare,
                                    calculateInfo.lowestFare,
                                    distance,
                                    (duration/60).toInt());

                                Map<String, dynamic> requestBody = {
                                  "fare": totalPrice.toInt(),
                                  "milage": distance,
                                  "routeSecond": duration.toInt(),
                                  "latitude": _currentPosition?.latitude ?? 0,
                                  "longitude": _currentPosition?.longitude ?? 0,
                                  "orderType": mainPageKey.currentState?.order_type ?? 1
                                };

                                await CreateTicketHistoryPriceApi().createTicketHistoryPrice(
                                    mainPageKey.currentState?.bill?.reservationId ?? 0,
                                    requestBody
                                );

                                GlobalDialog.showPaymentDialog(
                                  context,
                                  "結帳金額",
                                  "${totalPrice.toInt()}",
                                  '${distance.toStringAsFixed(1)}',
                                      () {
                                    StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                    statusProvider.updateStatus(GuestStatus.IS_NOT_OPEN);
                                    Navigator.pop(context);
                                  },
                                      () {
                                        // Navigator.pop(context);
                                  }
                                );
                              },
                              child: const Text(
                                '結束計費',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )
    );
  }
}
