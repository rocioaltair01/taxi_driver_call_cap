import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/util/dialog_util.dart';

import '../../respository/主畫面/order_request_api.dart';
import '../../respository/主畫面/submit_order_api.dart';
import 'main_page.dart';
import '細節頁/driver_map.dart';
import '細節頁/estimate_price.dart';
import '細節頁/hotspot_page.dart';


class OnlinePage extends StatefulWidget {
  const OnlinePage({super.key});

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  bool isLoading = false;
  InstantListModel? ticketDetail = InstantListModel(event: '', success: true,
    result: [ {"id": 1234}]
  );
  Map<String, dynamic>? submitTicket;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await OrderRequestAboveApi.getOrderRequestAbove(23.0091547, 120.174854);

      if (response.statusCode == 200) {
        setState(() {
          ticketDetail = response.data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
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
                                    child: SizedBox(
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
                              setState(() {
                                statusProvider.updateStatus(GuestStatus.IS_NOT_OPEN);
                              });
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
            Container(
              height: 300,
              color: Colors.white,// Set the height you desire
              child: ListView.builder(
                itemCount: ticketDetail?.result.length,
                itemBuilder: (context, index) {
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                              backgroundColor: Colors.grey,
                              //icon: Icons.shape_line,
                              label: "拒絕",
                              onPressed: (context){
                              }
                          ),
                          SlidableAction(
                              backgroundColor: Colors.red,
                              //icon: Icons.shape_line,
                              label: "搶單",
                              onPressed: (context) async{
                                // SubmitOrderResponse res = await  SubmitOrderApi.submitOrder(
                                //     passengerNum: 1,
                                //     passengerComment:"備註",
                                //     register: "4",
                                //     onLocationLng: 120.195,
                                //     onLocationLat: 23.013,
                                //     offLocationLng: 23,
                                //     offLocationLat: 120.2,
                                //     serviceList: null,
                                //     cars:1,
                                //     designationDriver: [],
                                //     customerId: 1,
                                //     passengerId: 1,
                                //     onLocation: "海佃路",
                                //     offLocation: null,
                                //     searchInterval: 1,
                                //     blackDriver: []
                                // );
                                // submitTicket = res.result;
                                DialogUtils.showGrabTicketDialog("12345","上車地點: 台南市中西區成功路1號","",context);

                                print('object $index');
                              }
                          )
                        ],
                      ),
                      child:
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("2.5公里"),
                            Text("上車地點:台南市中西區成功路1號"),
                            Text("上車地點:台南市中西區成功路1號"),
                            Text("備註:XXXX"),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      )
                  );
                },
              )
              // CustomScrollView(
              //   slivers: <Widget>[
              //     SliverList(
              //       delegate: SliverChildBuilderDelegate(
              //             (context, idx) {
              //           return Padding(
              //             padding: EdgeInsets.all(12),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("2.5公里"),
              //                 Text("上車地點:台南市中西區成功路1號"),
              //                 Text("上車地點:台南市中西區成功路1號"),
              //                 Text("備註:XXXX"),
              //                 Container(
              //                   height: 1,
              //                   color: Colors.black,
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //         childCount: 2,
              //       ),
              //     ),
              //   ],
              // ),
            ),

            Expanded(child: Container()),
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
                              borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                            ),
                            minimumSize: Size(double.infinity, 50), // Set the button height
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
                              borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                            ),
                            minimumSize: Size(double.infinity, 50), // Set the button height
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
      ],
    );
  }
}



