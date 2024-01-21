import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_panel/route_panel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:new_glad_driver/pages/%E4%B8%BB%E7%95%AB%E9%9D%A2/%E4%B8%8A%E4%B8%8B%E7%B7%9A/grab_success_page.dart';
import 'package:new_glad_driver/util/dialog_util.dart';

import '../../../model/error_res_model.dart';
import '../../../model/user_data_singleton.dart';
import '../../../model/主畫面/instant_item_model.dart';
import '../../../respository/主畫面/grab_ticket_api.dart';
import '../../../respository/主畫面/order_request_api.dart';
import '../main_page.dart';
import '../細節頁/driver_map.dart';
import '../細節頁/estimate_price.dart';
import '../細節頁/hotspot_page.dart';


class OnlinePage extends StatefulWidget {
  const OnlinePage({super.key});

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  String message = '';
  bool isLoading = false;
  List<InstantItemModel> ticketDetail = [];

  Map<String, dynamic>? submitTicket;
  LatLng? _currentPosition;
  late IO.Socket socket;
  int indexdialog = 0;
  bool isShowDialog = false;

  @override
  void initState() {
    super.initState();
    getLocation();
    connectSocket();
  }

  void connectSocket() {
    UserData loginResult = UserDataSingleton.instance;
    socket = IO.io('https://test-fleet-of-taxi.shopinn.tw', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': loginResult.token},
    });

    socket.onConnect((_) {
      print('@=== Socket: connected');
    });

    socket.onDisconnect((_) {
      print('@=== Socket: disconnected');
    });

    socket.onReconnect((_) {
      print('@=== Socket: reconnected');
    });

    socket.onReconnectAttempt((_) {
      print('@=== Socket: reconnect attempt');
    });

    socket.onError((error) {
      print('@=== Socket: error: $error');
    });

    socket.on('GetOrderInfo', (data) {
      if (mounted)
        fetchData();
      print('@=== Socket: Received GetOrderInfo event: $data');
    });

    // socket.on('Cancel', (data) {
    //   int cancelledOrderId = data['orderId']; // Assuming orderId is available in the 'Cancel' event data
    //   print('Socket: Received Cancel event: $data');
    //   if (mounted)
    //   {
    //     setState(() {
    //       ticketDetail.removeWhere((item) => item.orderId == cancelledOrderId);
    //     });
    //   }
    // });

    socket.connect();
  }

  @override
  void dispose() {
    super.dispose();
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
    _currentPosition = location;
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await OrderRequestAboveApi.getOrderRequestAbove(
          _currentPosition?.latitude ?? 0,
          _currentPosition?.longitude ?? 0,
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

      if (response.statusCode == 200) {
        if (mounted)
        {
          Set<int> uniqueOrderIds = Set();
          List<InstantItemModel> filteredTicketDetail = [];

          for (var item in response.data!) {
            if (!uniqueOrderIds.contains(item.orderId)) {
              filteredTicketDetail.add(item);
              uniqueOrderIds.add(item.orderId.toInt());
            }
          }

          setState(() {
            ticketDetail = filteredTicketDetail;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("@=== Failed getOrderRequestAbove $error");
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusProvider = Provider.of<StatusProvider>(context);
    return isLoading ? const Center(child: SpinKitFadingCircle(
      color: Colors.black,
      size: 80.0,
    ),) : Stack(
      children: [
        Column(
          children: [
            Container(
                height: 120,
                color: Colors.white,
                child: Column(
                  children: [
                    Text("message $message"),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    //padding: EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightGreenAccent,
                                    ),
                                    child: const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '上線接單中',
                                  style: TextStyle(
                                    color: Colors.black, // Set text color to black
                                    fontSize: 16, // Set font size as needed
                                  ),
                                ),
                              ],
                            )
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                              ),
                            ),
                            onPressed: () {
                              if (mounted)
                              {
                                setState(() {
                                  statusProvider.updateStatus(GuestStatus.IS_NOT_OPEN);
                                });
                              }
                            },
                            child: const Text(
                              '休息',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Expanded(
              //height: 300,
              //color: Colors.white,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.grey,
                                label: "拒絕",
                                onPressed: (context) {
                                  if (mounted)
                                    {
                                      setState(() {
                                        ticketDetail.removeWhere((item) => item.orderId == ticketDetail[index].orderId);
                                      });
                                    }
                                },
                              ),
                              SlidableAction(
                                backgroundColor: Colors.red,
                                label: "搶單",
                                onPressed: (context) async {
                                  setState(() {
                                    indexdialog = index;
                                    isShowDialog = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //here
                                Text(
                                    "${(ticketDetail[index].distance / 1000).toStringAsFixed(1)}公里",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                    ticketDetail[index].onLocation,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  ticketDetail[index].offLocation ?? "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  ticketDetail[index].note ?? "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: ticketDetail.length ?? 0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Column(
                        children: [
                          Container(height: 50,),
                          Container(height: 20,),
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
                                  builder: (context) => HotSpotPage()
                              ),
                            );
                          },
                          child: const Text(
                            '派單熱點',
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
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DriverMap()
                              ),
                            );
                          },
                          child: const Text(
                            '查看地圖',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        (isShowDialog) ?
        GrabTicketDialog(
          id: ticketDetail[indexdialog].orderId.toString(),
          title: "搶單",
          content: "上車地點: 台南市中西區成功路1號",
          time: (ticketDetail[indexdialog].time.toInt() == 0) ? 1 : ticketDetail[indexdialog].time.toInt(),
          onOkPressed: (double selectedTime) async{
            GrabTicketResponse response = await GrabTicketApi.grabTicket(
              orderId: ticketDetail[indexdialog].orderId.toString(),
              time: 1,
              status: 0,
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
            if (response.success)
            {
              if (mounted)
              {
                // setState(() {
                //  // ticketDetail.removeWhere((item) => item.orderId == ticketDetail[index].orderId);
                // });
                Navigator.push(context, BottomToTopPageRoute(page: GrabSuccessPage(orderId: ticketDetail[indexdialog].orderId.toInt(), selectedTime : selectedTime)));
              }
            } else {
              DialogUtils.showErrorDialog("", "搶單失敗", context);
            }
            setState(() {
              isShowDialog = false;
            });
          },
          onCancelPressed: () {
            setState(() {
              isShowDialog = false;
            });
          },
    ) : Container()
      ],
    );
  }
}



