import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/error_res_model.dart';
import '../../model/歷史訂單/immediate_list_model.dart';
import '../../model/預約單/reservation_model.dart';
import '../../respository/歷史訂單/immediate_ticket_api.dart';
import '../../util/dialog_util.dart';
import '../../util/shared_util.dart';
import '../tabbar_page.dart';
import '../主畫面/main_page.dart';
import 'components/date_header.dart';
import 'immediate_detail_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImmediateTicket extends StatefulWidget {
  const ImmediateTicket({super.key});

  @override
  _ImmediateTicketState createState() => _ImmediateTicketState();
}

class _ImmediateTicketState extends State<ImmediateTicket> {
  List<Bill> billList = [];
  List<int> colorCodes = [];
  DateTime now = DateTime.now();
  int year = 2023;
  int month = 8;
  bool isLoading = false;
  bool isEmpty = false;
  FixedExtentScrollController _dateYearController =
  FixedExtentScrollController(initialItem: 2);
  FixedExtentScrollController _dateMonthController =
  FixedExtentScrollController(initialItem: 2);
  List<String> monthNamesInChinese = [
    "一月", "二月", "三月", "四月", "五月", "六月",
    "七月", "八月", "九月", "十月", "十一月", "十二月"
  ];

  List<String> yearNamesInChinese = [];

  Future<void> fetchReservationTicketsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ImmediateTicketApi.getImmediateTickets(
          year,
          month,
          (res) {
            final jsonData = json.decode(res) as Map<String, dynamic>;
            ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
            GlobalDialog.showAlertDialog(
                context,
                "錯誤",
                responseModel.message
            );
          },
          () {
            GlobalDialog.showAlertDialog(context, "錯誤", "網路異常");
          }
      );

      if (response.statusCode == 200) {
        if (response.data.isEmpty) {
          setState(() {
            isEmpty = true;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            isEmpty = false;
            billList = response.data;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          isEmpty = true;
        });
        print("@=== Failed to fetch data fetchReservationTicketsData");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isEmpty = true;
      });
      print("@=== error6 $error");
      DialogUtils.showErrorDialog("錯誤","網路異常",context);
      throw Exception('Error: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    int selectedYear = year;
    int selectedMonth = month;

    final picked = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 280.0,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
                child: Center(child: Text("請選擇查詢月份")),
              ),
              Expanded(
                child:
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: CupertinoPicker(
                        scrollController: _dateYearController,
                        itemExtent: 38,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedYear = index + 2000; // Increment index by 1 as months are usually 1-based
                          });
                        },
                        children: List<Widget>.generate(24, (int index) {
                          return Text(
                            yearNamesInChinese[index], // Replace with your list of Chinese month names
                            style: const TextStyle(fontSize: 22.0),
                          );
                        }),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: CupertinoPicker(
                          itemExtent: 38,
                        scrollController: _dateMonthController,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedMonth = index + 1; // Increment index by 1 as months are usually 1-based
                            });
                          },
                          children: List<Widget>.generate(12, (int index) {
                            return Text(
                              monthNamesInChinese[index], // Replace with your list of Chinese month names
                              style: const TextStyle(fontSize: 22.0),
                            );
                          }),
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      year = selectedYear;
                      month = selectedMonth;
                    });
                    Navigator.pop(context, 'Complete');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 透明背景色
                    foregroundColor: Colors.black, // 文字颜色
                    minimumSize: const Size(double.infinity, 48), // 宽度填充并设置高度
                  ),
                  child: const Text('完成'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null && picked == 'Complete') {
      await fetchReservationTicketsData();
    }
  }

  @override
  void initState() {
    super.initState();
    year = now.year;
    month = now.month;
    yearNamesInChinese = DateUtil().generateYearList();
    _dateYearController = FixedExtentScrollController(initialItem: year);
    _dateMonthController = FixedExtentScrollController(initialItem: month);
    fetchReservationTicketsData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Material(
      child:
      Column(
        children: [
          DateHeader(
            year: year,
            month: month,
            onPressed: () {
              //Navigator.pop(context);
             _selectDate(context);
            },
          ),
          const Expanded(
            child: Center(
              child: SpinKitFadingCircle(
                color: Colors.black,
                size: 80.0,
              ),
            ),
          ),
        ],
      ),
    )
        : (isEmpty) ? Column(
      children: [
        DateHeader(
          year: year,
          month: month,
          onPressed: () {
            _selectDate(context);
          },
        ),
        const Expanded(
            child:
            Center(
                child:Text(
                  "沒有立即單歷史紀錄",
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
            )
        ),
      ],
    ) :
    Material(
      child:
      Column(
        children: [
          DateHeader(
            year: year,
            month: month,
            onPressed: () {
              _selectDate(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: billList.length,
              itemBuilder: (BuildContext context, int index) {
                String originalTime = billList[index].orderTime;
                DateTime parsedTime = DateTime.parse(originalTime).add(Duration(hours: 8));
                String formattedDate = DateFormat('M-d HH:mm(E)', 'zh').format(parsedTime);
                formattedDate = formattedDate.replaceAll("周", "週");
                return GestureDetector(
                  onTap: () {
                    // 派遣單直接到派遣流程
                    if (billList[index].orderStatus == 1) {
                      pertabbarPageKey.currentState?.setState(() {
                        pertabbarPageKey.currentState?.selectedTab = 2;
                      });

                      mainPageKey.currentState?.bill = BillInfoResevation(
                        driverId: "",
                        orderStatus: billList[index].orderStatus ?? 0,
                        reservationId: billList[index].id,
                        onLocation: billList[index].onLocation ?? "",
                        offLocation: billList[index].offLocation ?? "",
                        reservationType: "",
                        reservationTime: "",
                        passengerNote: billList[index].passengerNote ?? "",
                        onGps: billList[index].onGps ?? [],
                        offGps: billList[index].offGps ?? [],
                        userNumber: 0,
                        acknowledgingOrderMethods: 0,
                        serviceList: "",
                        reservationTeam: "",
                        blacklist: "",
                        createdAt: "",
                        clickMeterDate: null,
                        getInTime: null,
                        getPassengerTime: null,
                        passengerOnLocationNote: "",
                        isDeal: "",
                      );
                      StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                      mainPageKey.currentState?.order_type = 0;
                      statusProvider.updateStatus(GuestStatus.PREPARED);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImmediateDetailPage(
                              orderNumber: billList[index].id,
                              orderStatus: billList[index].orderStatus,
                            )
                        ),
                      );
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            (billList[index].orderStatus == 1 || billList[index].orderStatus == 2) ? 'assets/images/status2and3_icon.png'
                                : (billList[index].orderStatus == 3) ? 'assets/images/ok.png' : 'assets/images/no.png',
                            width: 30,
                            height: 30,
                          ),
                        ),// Show a progress indicator or other UI during startup

                        Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),// Handle long text
                                  ),
                                  Text(
                                    '從: ${billList[index].onLocation}',
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '到: ${billList[index].offLocation}',
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


