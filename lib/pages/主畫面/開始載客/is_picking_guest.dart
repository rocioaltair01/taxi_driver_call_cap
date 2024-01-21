import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/error_res_model.dart';
import '../../../model/user_data_singleton.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/arrived_destination_api.dart';
import '../../../respository/主畫面/create_ticket_history_price_api.dart';
import '../../../util/shared_util.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

class IsPickingQuestPage extends StatefulWidget {
  final BillInfoResevation? bill;
  const IsPickingQuestPage({super.key, this.bill});

  @override
  State<IsPickingQuestPage> createState() => _IsPickingQuestPageState();
}

class _IsPickingQuestPageState extends State<IsPickingQuestPage> {
  late GoogleMapController mapController;
  double price = 100;
  double duration = 0;
  double distance = 0;
  Timer? distanceTimer;
  Timer? timeTimer;
  String pick_status = "前往載客中";
  LatLng? _currentPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
      CalculatedInfo calculateInfo = UserDataSingleton.instance.setting.calculatedInfo;
      setState(() {
        print("ROCIO: price $price distance $distance duration $duration");
        price = PriceUtil().calculateTotalCost(
            calculateInfo.perKmOfFare,
            calculateInfo.perMinOfFare,
            calculateInfo.initialFare,
            calculateInfo.upPerKmOfFare,
            calculateInfo.extraFare,
            calculateInfo.lowestFare,
            distance,
            (duration/60).toInt());
      });
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              (_currentPosition != null) ?
              Stack(
                children: [
                  Container(
                    height: 250,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition ?? LatLng(0, 0),
                        zoom: 16.0,
                      ),
                      myLocationEnabled: true,
                    ),
                  ),
                  Positioned(
                      top: 50,
                      left: 20,
                      child: Text(
                        pick_status,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ) : Container(
                height: 250,
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 0,
                child: Text(
                    pick_status,
                  style: const TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight - 250 - 160 - 85,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "跳表金額: ${price.toInt()} 元",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text(
                                  "分鐘數: ${double.parse((duration/60).toStringAsFixed(1))} 分",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Text(
                                  "里程數: ${distance.toStringAsFixed(1)} 公里",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const Text(
                                  "訂單編號:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                (widget.bill != null) ?
                                Text(
                                  widget.bill!.reservationId.toString(),
                                  style: const TextStyle(
                                    color: Colors.black, // Set text color to black
                                    fontSize: 20, // Set font size as needed
                                  ),
                                ) : Container()
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "上車定點：",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    (widget.bill != null) ?
                                    Text(
                                      widget.bill!.onLocation.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          overflow: TextOverflow.clip
                                      ),
                                    ) : Container()
                                  ],
                                )),
                                InkWell(
                                  onTap: () {
                                    print("openGoogleMap ${widget.bill!.onLocation}");
                                    openGoogleMap(widget.bill!.onLocation);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/images/location.png',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("地點：",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    (widget.bill != null) ?
                                    Text(
                                      widget.bill!.offLocation.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          overflow: TextOverflow.clip
                                      ),
                                    ) : Container()
                                  ],
                                ),),
                                InkWell(
                                  onTap: () {
                                    openGoogleMap(widget.bill!.offLocation);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/images/location.png',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            const Text("備註：",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            (widget.bill != null) ?
                            Text(
                              widget.bill!.passengerNote,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ) : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          minimumSize: const Size(double.infinity, 50),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const EstimatePrice()
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          '估算金額',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(height: 20,),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          minimumSize: const Size(double.infinity, 50),
                                        ),
                                        onPressed: () async{
                                          if (mainPageKey.currentState?.bill?.reservationId != null) {
                                            ArrivedDestinationApiResponse result = await ArrivedDestinationApi().markArrivedDestination(
                                                orderId: mainPageKey.currentState?.bill?.reservationId ?? 0,
                                                orderType: mainPageKey.currentState?.order_type ?? 1,
                                                onError: (res) {
                                                  final jsonData = json.decode(res) as Map<String, dynamic>;
                                                  ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
                                                  GlobalDialog.showAlertDialog(
                                                      context,
                                                      "錯誤",
                                                      responseModel.message
                                                  );
                                                }
                                            );
                                            if (result.success == true)
                                            {
                                              CalculatedInfo calculateInfo = UserDataSingleton.instance.setting.calculatedInfo;
                                              double totalPrice = PriceUtil().calculateTotalCost(
                                                  calculateInfo.perKmOfFare,
                                                  calculateInfo.perMinOfFare,
                                                  calculateInfo.initialFare,
                                                  calculateInfo.upPerKmOfFare,
                                                  calculateInfo.extraFare,
                                                  calculateInfo.lowestFare,
                                                  distance,
                                                  (duration/60).toInt()
                                              );

                                              if (widget.bill != null) {
                                                //?????
                                                print("heyy ${widget.bill!.onGps}");
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
                                                    requestBody,
                                                    (res) {
                                                      final jsonData = json.decode(res) as Map<String, dynamic>;
                                                      ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
                                                      GlobalDialog.showAlertDialog(
                                                          context,
                                                          "錯誤",
                                                          responseModel.message
                                                      );
                                                    }
                                                );
                                              }
                                              GlobalDialog.showPaymentDialog(
                                                  context,
                                                  "結帳金額",
                                                  "${totalPrice.toInt()}",
                                                  '${distance.toStringAsFixed(1)}',
                                                      () {
                                                    StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                                    statusProvider.updateStatus(GuestStatus.IS_OPEN);
                                                  },
                                                      () {
                                                  });
                                            } else {
                                              GlobalDialog.showAlertDialog(context, "結束載客失敗", result.message);
                                            }
                                          }
                                        },
                                        child: const Text(
                                          '結束載客',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Container(width: 60,),
                              Expanded(
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          minimumSize: const Size(double.infinity, 50),
                                        ),
                                        onPressed: () {

                                        },
                                        child: const Text(
                                          '聯絡客人',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(height: 20,),
                                      Container(height: 50,)
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  void openGoogleMap(String endAddress) async {
    double currentLat = _currentPosition?.latitude ?? 0;
    double currentLng = _currentPosition?.longitude ?? 0;

    if (endAddress.isNotEmpty) {
      String url = 'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$endAddress';
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Please enter start and end addresses');
    }
  }
}
