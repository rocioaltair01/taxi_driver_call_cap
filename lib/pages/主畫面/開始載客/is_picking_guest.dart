import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled1/util/dialog_util.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/arrived_destination_api.dart';
import '../../../respository/主畫面/giveup_api.dart';
import '../../../respository/主畫面/start_picking_passenger_api.dart';
import '../細節頁/customer_message_page.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

class IsPickingQuestPage extends StatefulWidget {
  final BillList bill;
  const IsPickingQuestPage({super.key, required this.bill});

  @override
  State<IsPickingQuestPage> createState() => _IsPickingQuestPageState();
}

class _IsPickingQuestPageState extends State<IsPickingQuestPage> {
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
      //_isOpen = false;
    });
  }
  String pick_status = "前往載客中";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 16.0,
                  ),
                  myLocationEnabled: true,
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 0,
                child: Text("$pick_status"),
              ),
            ],
          ),


          //Expanded(child: Container()),
          Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "訂單編號:",
                              style: TextStyle(
                                color: Colors.black, // Set text color to black
                                fontSize: 16, // Set font size as needed
                              ),
                            ),
                            Text(
                              widget.bill.billInfo.reservationId.toString(),
                              style: TextStyle(
                                color: Colors.black, // Set text color to black
                                fontSize: 16, // Set font size as needed
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "上車定點：",
                                  style: TextStyle(
                                    color: Colors.black, // Set text color to black
                                    fontSize: 16, // Set font size as needed
                                  ),
                                ),
                                Text(
                                  widget.bill.billInfo.onLocation.toString(),
                                  style: TextStyle(
                                    color: Colors.black, // Set text color to black
                                    fontSize: 20, // Set font size as needed
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                              },
                              child: Container(
                                padding: EdgeInsets.all(12), // Set padding as needed
                                child: Image.asset(
                                  'assets/images/location.png', // Replace with your image path
                                  width: 20, // Set width as needed
                                  height: 20, // Set height as needed
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("下車定點：",
                                    style: TextStyle(
                                      color: Colors.black, // Set text color to black
                                      fontSize: 16, // Set font size as needed
                                    ),
                                  ),
                                  Text(
                                    widget.bill.billInfo.offLocation.toString(),
                                    style: TextStyle(
                                      color: Colors.black, // Set text color to black
                                      fontSize: 20, // Set font size as needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Expanded(child: Container()),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                              },
                              child: Container(
                                padding: EdgeInsets.all(12), // Set padding as needed
                                child: Image.asset(
                                  'assets/images/location.png', // Replace with your image path
                                  width: 20, // Set width as needed
                                  height: 20, // Set height as needed
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            )
                          ],
                        ),
                        Text("備註：",
                          style: TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 16, // Set font size as needed
                          ),
                        ),
                        Text(
                          widget.bill.billInfo.passengerNote,
                          style: TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 20, // Set font size as needed
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child:  Padding(
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
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(height: 20,),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null) {
                                          ArrivedDestinationApiResponse result = await ArrivedDestinationApi().markArrivedDestination(
                                              mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0, 1);
                                          if (result.success == true)
                                          {
                                            GlobalDialog.showAlertDialog(context, "結帳金額成功", result.message);
                                            // mainPageKey.currentState?.setState(() {
                                            //   mainPageKey.currentState?.current_status = GuestStatus.IS_OPEN;
                                            // });
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
                            Container(width: 180,)
                          ],
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
}
