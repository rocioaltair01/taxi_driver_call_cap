import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/arrived_destination_api.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

class IsPickingQuestPage extends StatefulWidget {
  final BillList? bill;
  const IsPickingQuestPage({super.key, this.bill});

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
                        style: TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ) : Container(
                height: 250,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0,0),
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
                      children: [
                        Row(
                          children: [
                            Text(
                              "訂單編號:",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            (widget.bill != null) ?
                            Text(
                              widget.bill!.billInfo.reservationId.toString(),
                              style: TextStyle(
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
                                Text(
                                  "上車定點：",
                                  style: TextStyle(
                                    color: Colors.black, // Set text color to black
                                    fontSize: 18, // Set font size as needed
                                  ),
                                ),
                                (widget.bill != null) ?
                                Text(
                                  widget.bill!.billInfo.onLocation.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      overflow: TextOverflow.clip
                                  ),
                                ) : Container()
                              ],
                            )),
                            InkWell(
                              onTap: () {
                                print("openGoogleMap ${widget.bill!.billInfo.onLocation}");
                                openGoogleMap(widget.bill!.billInfo.onLocation);
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
                        Row(
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("下車定點：",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                (widget.bill != null) ?
                                Text(
                                  widget.bill!.billInfo.offLocation.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                      overflow: TextOverflow.clip
                                  ),
                                ) : Container()
                              ],
                            ),),
                            //Expanded(child: Container()),
                            InkWell(
                              onTap: () {
                                print("openGoogleMap ${widget.bill!.billInfo.offLocation}");
                                openGoogleMap(widget.bill!.billInfo.offLocation);
                              },
                              child: Container(
                                padding: EdgeInsets.all(12), // Set padding as needed
                                child: Image.asset(
                                  'assets/images/location.png', // Replace with your image path
                                  width: 30, // Set width as needed
                                  height: 30, // Set height as needed
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Text("備註：",
                          style: TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 16, // Set font size as needed
                          ),
                        ),
                        (widget.bill != null) ?
                        Text(
                          widget.bill!.billInfo.passengerNote,
                          style: TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 20, // Set font size as needed
                          ),
                        ) : Container()
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
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.IS_OPEN);
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
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
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
    print("openGoogleMap");
    // String startAddress = widget.addressFieldControllers[0].text;
    // String endAddress = widget.addressFieldControllers[widget.addressFieldControllers.length-1].text;
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
