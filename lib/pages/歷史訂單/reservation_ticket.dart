
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/歷史訂單/reservation_list_model.dart';
import '../../respository/歷史訂單/reservation_ticket_api.dart';
import '../../util/dialog_util.dart';
import '../../util/shared_util.dart';
import 'components/date_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'reservation_detail_page.dart';

class ReservationTicket extends StatefulWidget {
  @override
  _ReservationTicketState createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  List<ReservationInfo> billList = [];
  List<int> colorCodes = [];
  DateTime now = DateTime.now();
  int year = 2023;
  int month = 7;
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

  String reservationTime = "";
  DateTime? parsedOrderTime;
  String formattedDateOrderTime = "";

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ReservationTicketApi.getReservationTickets(year, month);

      if (response.statusCode == 200) {
        if (response.data.isEmpty) {
          setState(() {
            isLoading = false;
            isEmpty = true;
          });
        } else {
          setState(() {
            isEmpty = false;
            isLoading = false;
            billList = response.data;
          });
        }
      } else {
        setState(() {
          isEmpty = true;
          isLoading = false;
        });
        DialogUtils.showErrorDialog("錯誤","請求異常",context);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isEmpty = true;
        isLoading = false;
      });
      print("@=== getReservationTickets Failed");
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
      await fetchData(); // Fetch data with the updated year and month
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading // Check if isLoading is true
        ? Column(
      children: [
        DateHeader(
          year: year,
          month: month,
          onPressed: () {
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
    ) : (isEmpty) ? Column(
      children: [
        DateHeader(
          year: year,
          month: month,
          onPressed: () {
            _selectDate(context);
          },
        ),
        const Expanded(
          child: Center(child: Text(
              "沒有預約單歷史紀錄",
            style: TextStyle(
                fontSize: 18
            ),
          ))
        ),
      ],
    ) : Container(
      child: Column(
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
                reservationTime = billList[index].billInfo.reservationTime!.toString();
                parsedOrderTime = DateTime.parse(reservationTime).add(Duration(hours: 8));
                formattedDateOrderTime = DateFormat('M-d HH:mm(E)', 'zh').format(parsedOrderTime!);
                formattedDateOrderTime = formattedDateOrderTime.replaceAll("周", "週");
                return GestureDetector(
                    onTap: () {
                      print('Item at index $index ${billList[index].billInfo.reservationId}:: ${billList[index].billInfo.orderStatus}');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReservationDetailPage(orderNumber: billList[index].billInfo.reservationId ?? 0, orderStatus: billList[index].billInfo.orderStatus ?? 0,)
                        ),
                      );
                    },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            (billList[index].billInfo.orderStatus == 1 || billList[index].billInfo.orderStatus == 2) ? 'assets/images/status2and3_icon.png'
                                : (billList[index].billInfo.orderStatus == 3) ? 'assets/images/ok.png' : 'assets/images/no.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDateOrderTime,
                                    overflow: TextOverflow.clip, // Handle long text
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // You can add more styles like fontWeight, color, etc. as needed
                                    ),
                                  ),
                                  Text(
                                    '從: ${billList[index].billInfo.onLocation}',
                                    overflow: TextOverflow.clip, // Handle long text
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // You can add more styles like fontWeight, color, etc. as needed
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



