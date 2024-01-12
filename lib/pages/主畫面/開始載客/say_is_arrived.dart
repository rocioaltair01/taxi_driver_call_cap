import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/主畫面/giveup_api.dart';
import '../../../respository/主畫面/start_picking_passenger_api.dart';
import '../../../respository/主畫面/update_arrive_photo.dart';
import '../../../respository/主畫面/update_friday_time_api.dart';
import '../上下線/offline_count_price_page.dart';
import '../細節頁/estimate_price.dart';
import '../main_page.dart';

enum PickingStatus {
  ARRIVED,// 點選到達定點
  ARRIVED_5MIN,// 點選到達定點（5min）
  ARRIVED_10MIN,// 點選到達定點（10min）
  GIVINGUP,// 申請放棄中（10min）
}


class SayIsArrivedPage extends StatefulWidget {
  final BillInfoResevation? bill;
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
  bool showCamera = false;
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;


  @override
  void initState() {
    super.initState();
    getLocation();
    startTimer();
    print("ccc $cameras");
    // _controller = CameraController(
    //   cameras.first,
    //   ResolutionPreset.medium,
    // );
    //
    // _initializeControllerFuture = _controller.initialize();
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
      print("say_is_arrived $_currentPosition ");
      //_isOpen = false;
    });
  }
  String pick_status = "前往載客中";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (showCamera) ? Scaffold(
      appBar: AppBar(
        title: Text('相機'),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
               showCamera = false;
             });
            },
          ),
        ],
      ),
      body: TakePictureScreen(bill: widget.bill)
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
                                Text(
                                  widget.bill != null ? widget.bill!.reservationId.toString() : '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
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
                                      widget.bill != null ? widget.bill!.onLocation.toString() : '',
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
                                    openGoogleMap(widget.bill!.onLocation);
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
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("地點：",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        widget.bill != null ? widget.bill!.offLocation.toString() : '',
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
                            SizedBox(height: 10,),
                            const Text("備註：",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.bill != null ? widget.bill!.passengerNote.toString() : '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
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
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {

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
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(
                                              mainPageKey.currentState?.bill?.reservationId ?? 0,
                                              mainPageKey.currentState?.order_type ?? 1
                                          );
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
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        await UpdateFridayTimeApi().updateFridayTime(
                                            widget.bill!.reservationId,
                                            mainPageKey.currentState!.order_type
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OfflineCountPricePage()
                                          ),
                                        );
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
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
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
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(
                                              mainPageKey.currentState?.bill?.reservationId ?? 0,
                                              mainPageKey.currentState?.order_type ?? 1
                                          );
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
                                              if (mainPageKey.currentState?.bill?.reservationId != null) {
                                                GiveupErrorResponse result = await GiveupApi().cancelOrderApply(mainPageKey.currentState?.bill?.reservationId ?? 0,
                                                    mainPageKey.currentState?.bill?.orderStatus ?? 1);
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
                                        style: const TextStyle(
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
                                      minimumSize: const Size(double.infinity, 50), // Set the button height
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
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(
                                              mainPageKey.currentState?.bill?.reservationId ?? 0,
                                              mainPageKey.currentState?.order_type ?? 1
                                          );
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
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
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
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
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
                                        minimumSize: const Size(double.infinity, 50), // Set the button height
                                      ),
                                      onPressed: () async{
                                        if (mainPageKey.currentState?.bill?.reservationId != null)
                                        {
                                          StartPickingPassengerApiResponse res = await StartPickingPassengerApi().startPickingPassenger(
                                              mainPageKey.currentState?.bill?.reservationId ?? 0,
                                              mainPageKey.currentState?.order_type ?? 1
                                          );
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
                  Text ("Error")
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


// // A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final BillInfoResevation? bill;

  const TakePictureScreen({
    this.bill,
    super.key,
  });
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
      cameras.first,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Column(
        children: [
          // Container(
          //   height: 200,
          //   child:    TakePictureScreen(),
          // ),

          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
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
                        if (_controller != null)
                        {
                          print("object");
                          _controller.takePicture().then((XFile? file) {
                            if(mounted) {
                              print("objectee $file ${widget.bill}");
                              if(file != null && widget.bill != null) {
                                print("objecteedfd");
                                print("Picture saved to ${file.path}");
                                UpdateArrivePhotoApi.updateArrivePhoto(
                                    filePath: file.path,
                                    orderId: widget.bill!.reservationId ?? 0,
                                    orderType: mainPageKey.currentState!.order_type
                                );
                              }
                            }
                          });
                        }
                        setState(() {
                         // showCamera = false;
                        });
                      },
                      child: Container()
                  ),
                ),

              )
          )
        ],
      )
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}