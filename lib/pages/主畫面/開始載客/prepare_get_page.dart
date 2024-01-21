import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_glad_driver/util/google_map_util.dart';
import 'package:provider/provider.dart';
import 'package:new_glad_driver/pages/%E4%B8%BB%E7%95%AB%E9%9D%A2/%E7%B4%B0%E7%AF%80%E9%A0%81/customer_message_page.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/error_res_model.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/arrived_success_api.dart';
import '../../../respository/主畫面/get_ticket_status_api.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

//status- number- 0 (未結束訂單), 1 (訂單完成), 2(司機取消), 3(乘客取消)
enum TicketStatus {
  UNFINISHED,
  FINISH,
  DRIVER_CANCEL,
  PASSENGER_CANCEL
}

class PrepareGetPage extends StatefulWidget {
  final BillInfoResevation? bill;
  const PrepareGetPage({super.key, this.bill});

  @override
  State<PrepareGetPage> createState() => _PrepareGetPageState();
}

class _PrepareGetPageState extends State<PrepareGetPage> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Timer? getTicketStatusTimer;
  TicketStatus ticketStatus = TicketStatus.UNFINISHED;
  bool isShowCancelDialog = false;

  @override
  void initState() {
    super.initState();
    getLocation();
    startGetTicketStatusTimer();
  }

  @override
  void dispose() {
    getTicketStatusTimer?.cancel();
    super.dispose();
  }

  void startGetTicketStatusTimer() {
    getTicketStatusTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      GetTicketStatusApiResponse res = await GetTicketStatusApi().getTicketStatus(
          widget.bill!.reservationId,
          mainPageKey.currentState?.order_type ?? 1,
          (res) {
            final jsonData = json.decode(res) as Map<String, dynamic>;
            ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
            GlobalDialog.showAlertDialog(
                context,
                "錯誤",
                responseModel.message
            );
          });
      //status- number- 0 (未結束訂單), 1 (訂單完成), 2(司機取消), 3(乘客取消)
      //status = 2,3 都屬於取消
      if (res.status == 0) {
        setState(() {
          ticketStatus = TicketStatus.UNFINISHED;
        });
      } else if (res.status == 1) {
        setState(() {
          ticketStatus = TicketStatus.FINISH;
        });
      } else if (res.status == 2) {
        setState(() {
          ticketStatus = TicketStatus.DRIVER_CANCEL;
        });
        if (!isShowCancelDialog) {
          DialogUtils.showCancelTicketCenterDialog(context, "訂單已取消", () {
            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
            statusProvider.updateStatus(GuestStatus.IS_NOT_OPEN);
          });
          isShowCancelDialog = true;
        }
      } else if (res.status == 3) {
        setState(() {
          ticketStatus = TicketStatus.PASSENGER_CANCEL;
        });
        if (!isShowCancelDialog) {
          DialogUtils.showCancelTicketCenterDialog(context, "訂單已取消", () {
            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
            statusProvider.updateStatus(GuestStatus.IS_NOT_OPEN);
          });
          isShowCancelDialog = true;
        }
      }
    });
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
                    target: _currentPosition!,
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
                                    GoogleMapUtil().openGoogleMap(widget.bill!.offLocation,_currentPosition);
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
                                    GoogleMapUtil().openGoogleMap(widget.bill!.offLocation,_currentPosition);
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
                                      GestureDetector(
                                        onDoubleTap:() async{
                                          if (mainPageKey.currentState?.bill?.reservationId != null)
                                          {
                                            ArrivedSuccessApiResponse res = await ArrivedSuccessApi().markArrivalSuccess(
                                                mainPageKey.currentState?.bill?.reservationId ?? 0,
                                                mainPageKey.currentState?.order_type ?? 1,
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                                          ),
                                          height: 50,
                                          child: const Center(
                                            child: Text(
                                              '已到定點',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        )
                                      )
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
                                          minimumSize: const Size(double.infinity, 50),
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
}
