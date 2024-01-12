import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_glad_driver/pages/%E4%B8%BB%E7%95%AB%E9%9D%A2/%E7%B4%B0%E7%AF%80%E9%A0%81/customer_message_page.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/arrived_success_api.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

class PrepareGetPage extends StatefulWidget {
  final BillInfoResevation? bill;
  const PrepareGetPage({super.key, this.bill});

  @override
  State<PrepareGetPage> createState() => _PrepareGetPageState();
}

class _PrepareGetPageState extends State<PrepareGetPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
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
              const Positioned(
                top: 50,
                left: 20,
                child: Text(
                    "前往載客中",
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              )
            ],
          ) : Container(
            height: 250,
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
                                    color: Colors.black,
                                    fontSize: 20,
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
                                ),
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
                                          fontSize: 18, overflow: TextOverflow.clip
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                                ),
                                InkWell(
                                  onTap: () {
                                    openGoogleMap(widget.bill!.offLocation);
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            const Text("備註：",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            (widget.bill != null) ?
                            Text(
                              widget.bill!.passengerNote,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ) : Container(),
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
                                          minimumSize: Size(double.infinity, 50),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EstimatePrice()
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          '估算金額',
                                          style: TextStyle(
                                            fontSize: 18,
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
                                          if (mainPageKey.currentState?.bill?.reservationId != null)
                                          {
                                            print("markArrivalSuccess ${mainPageKey.currentState?.bill?.orderStatus}");
                                            ArrivedSuccessApiResponse res = await ArrivedSuccessApi().markArrivalSuccess(
                                                mainPageKey.currentState?.bill?.reservationId ?? 0,
                                                mainPageKey.currentState?.order_type ?? 1
                                              // 0
                                            );
                                            if (res.success == true)
                                            {
                                              StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                              statusProvider.updateStatus(GuestStatus.ARRIVED);
                                              //GlobalDialog.showAlertDialog(context, "回報到達成功", "message");
                                            } else {
                                              GlobalDialog.showAlertDialog(context, "not success", "message");
                                            }
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "no", "message");
                                          }
                                        },
                                        child: const Text(
                                          '已到定點',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                width: 30,
                              ),
                              Expanded(
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          minimumSize: Size(double.infinity, 50),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CustomerMessagePage()
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          '聯絡客人',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(height: 70,)
                                    ],
                                  )
                              )
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
