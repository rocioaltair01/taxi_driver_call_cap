import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/giveup_api.dart';
import '../../../respository/主畫面/start_picking_passenger_api.dart';
import '../細節頁/customer_message_page.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

enum PickingStatus {
  ARRIVED,// 點選到達定點
  ARRIVED_5MIN,// 點選到達定點（5min）
  ARRIVED_10MIN,// 點選到達定點（10min）
  GIVINGUP,// 申請放棄中（10min）
}


class SayIsArrivedPage extends StatefulWidget {
  final BillList? bill;
  const SayIsArrivedPage({super.key, this.bill});

  @override
  State<SayIsArrivedPage> createState() => _SayIsArrivedPageState();
}

class _SayIsArrivedPageState extends State<SayIsArrivedPage> {
  late GoogleMapController mapController;
  bool isGivingup = false;
  PickingStatus current_status = PickingStatus.ARRIVED;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  LatLng? _currentPosition;
  late CameraController controller;
  bool showCamera = false;
  // late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    getLocation();
    startTimer();
    if (cameras.isNotEmpty)
    {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
            // Handle access errors here.
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
    }
  }

  void startTimer() {
    const Duration duration5 = Duration(minutes: 5);
    Timer(duration5, () {
      // 这里是计时器结束后执行的代码
      print('5分钟已经过去了！');
      setState(() {
        current_status = PickingStatus.ARRIVED_5MIN;
      });

    });
    const Duration duration = Duration(minutes: 10);
    Timer(duration, () {
      // 这里是计时器结束后执行的代码
      print('10分钟已经过去了！');
      setState(() {
        current_status = PickingStatus.ARRIVED_10MIN;
      });
    });
    print('计时器已启动，将在5分钟后执行代码。');
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
    var size = MediaQuery.of(context).size.width;

    return (showCamera) ? Scaffold(
      appBar: AppBar(
        title: Text('Your App Title'),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              // Navigate back (pop) when cancel button is pressed
             setState(() {
               showCamera = false;
             });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: CameraPreview(controller),
          ),
          Expanded(
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0), // Make it circular
                      ),
                      minimumSize: const Size(50, 50),
                    ),
                    onPressed: () {
                      controller.takePicture().then((XFile? file) {
                        if(mounted) {
                          if(file != null) {
                            print("Picture saved to ${file.path}");
                          }
                        }
                      });
                      setState(() {
                        showCamera = false;
                      });
                    },
                    child: Container()
                  ),
                ),

              )
          )

        ],
      ),
    ) : Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              (_currentPosition != null) ?
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
          Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "訂單編號:",
                              style: TextStyle(
                                color: Colors.black, // Set text color to black
                                fontSize: 18, // Set font size as needed
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              widget.bill != null ? widget.bill!.billInfo.reservationId.toString() : '',
                              style: const TextStyle(
                                color: Colors.black, // Set text color to black
                                fontSize: 20, // Set font size as needed
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
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
                                Text(
                                  widget.bill != null ? widget.bill!.billInfo.onLocation.toString() : '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                      overflow: TextOverflow.clip
                                  ),
                                ),
                              ],
                            ),),
                            InkWell(
                              onTap: () {
                                openGoogleMap(widget.bill!.billInfo.onLocation);
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
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("下車定點：",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    widget.bill != null ? widget.bill!.billInfo.offLocation.toString() : '',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        overflow: TextOverflow.clip
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                            //Expanded(child: Container()),
                            InkWell(
                              onTap: () {
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
                        SizedBox(height: 10,),
                        const Text("備註：",
                          style: TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 18, // Set font size as needed
                          ),
                        ),
                        Text(
                          widget.bill != null ? widget.bill!.billInfo.passengerNote.toString() : '',
                          style: const TextStyle(
                            color: Colors.black, // Set text color to black
                            fontSize: 20, // Set font size as needed
                          ),
                        )
                      ],
                    ),
                  ),
                  (current_status == PickingStatus.ARRIVED) ?
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
                                    Container(height: 50,)
                                  ],
                                )
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child:  Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                      ),
                                      minimumSize: Size(double.infinity, 50), // Set the button height
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showCamera = true;
                                      });
                                    },
                                    child: const Text(
                                      '拍照',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(height: 20,),
                                  Container(height: 50,),
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                  //     ),
                                  //     minimumSize: Size(double.infinity, 50), // Set the button height
                                  //   ),
                                  //   onPressed: () {
                                  //   },
                                  //   child: const Text(
                                  //     '週五跳錶',
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
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
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            setState(() {
                                              pick_status = "前往目的地";
                                            });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            // setState(() {
                                            //   pick_status = "前往目的地";
                                            // });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        '已載客',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ) :
                  (current_status == PickingStatus.ARRIVED_5MIN) ?
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
                                        minimumSize: Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () {
                                      },
                                      child: const Text(
                                        '週五跳錶',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child:  Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                      ),
                                      minimumSize: Size(double.infinity, 50), // Set the button height
                                    ),
                                    onPressed: () {
                                    },
                                    child: const Text(
                                      '拍照',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(height: 20,),
                                  Container(height: 50,),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
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
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            setState(() {
                                              pick_status = "前往目的地";
                                            });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: Size(double.infinity, 50), // Set the button height
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
                                        '已載客',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ) :
                  (current_status == PickingStatus.ARRIVED_10MIN) ?
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
                                        backgroundColor: isGivingup ? Colors.grey : Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        minimumSize: const Size(double.infinity, 50),
                                      ),
                                      onPressed: () async{
                                        GlobalDialog.showGiveupDialog(
                                            context: context,
                                            message: "確定要申請放棄訂單嗎？",
                                            onOkPressed: () async{
                                              if (mainPageKey.currentState?.bill?.billInfo.reservationId != null) {
                                                GiveupErrorResponse result = await GiveupApi().cancelOrderApply(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0,
                                                    mainPageKey.currentState?.bill?.billInfo.orderStatus ?? 1);
                                                print("result.success ${result.success}");
                                                if (result.success == true)
                                                {
                                                  // mainPageKey.currentState?.setState(() {
                                                  //   mainPageKey.currentState?.say_is_arrived = false;
                                                  // });
                                                  setState(() {
                                                    isGivingup = true;
                                                  });
                                                  // GlobalDialog.showAlertDialog(context, "放棄成功", result.message);
                                                } else {
                                                  GlobalDialog.showAlertDialog(context, "申請放棄失敗", result.message);
                                                }
                                              }
                                            },
                                            onCancelPressed: () {

                                            }
                                        );
                                      },
                                      child: Text(
                                        isGivingup ? '申請放棄中' : '申請放棄',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child:  Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                      ),
                                      minimumSize: Size(double.infinity, 50), // Set the button height
                                    ),
                                    onPressed: () {
                                    },
                                    child: const Text(
                                      '拍照',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(height: 20,),
                                  Container(height: 50,),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
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
                                      onPressed: () async{

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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            setState(() {
                                              pick_status = "前往目的地";
                                            });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        '已載客',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ) :
                  (current_status == PickingStatus.GIVINGUP) ?
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
                                        minimumSize: Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () {
                                      },
                                      child: const Text(
                                        '申請放棄中',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child:  Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                      ),
                                      minimumSize: Size(double.infinity, 50), // Set the button height
                                    ),
                                    onPressed: () {
                                    },
                                    child: const Text(
                                      '拍照',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(height: 20,),
                                  Container(height: 50,),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
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
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            setState(() {
                                              pick_status = "前往目的地";
                                            });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                                        ),
                                        minimumSize: Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.billInfo.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(mainPageKey.currentState?.bill?.billInfo.reservationId ?? 0);
                                          if (res.success)
                                          {
                                            StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                                            statusProvider.updateStatus(GuestStatus.PICKING_GUEST);
                                            setState(() {
                                              pick_status = "前往目的地";
                                            });
                                            //GlobalDialog.showAlertDialog(context, "開始載客成功", res.message);
                                          } else {
                                            GlobalDialog.showAlertDialog(context, "開始載客失敗", res.message);
                                          }
                                        }
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => CustomerMessagePage()
                                        //   ),
                                        // );
                                      },
                                      child: const Text(
                                        '已載客',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      )
                  ) :
                  Text ("Error")
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

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Container();
  }
}