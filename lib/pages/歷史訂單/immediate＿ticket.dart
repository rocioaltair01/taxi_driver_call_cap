import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/歷史訂單/immediate_list_model.dart';
import '../../respository/歷史訂單/immediate_ticket_api.dart';
import '../../util/dialog_util.dart';
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

  List<String> yearNamesInChinese = [
    "2000年", "2001年", "2002年", "2003年", "2004年", "2005年", "2006年", "2007年",
    "2008年", "2009年", "2010年", "2011年", "2012年", "2013年", "2014年", "2015年",
    "2016年", "2017年", "2018年", "2019年", "2020年", "2021年", "2022年", "2023年"
  ];

  Future<void> fetchReservationTicketsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ImmediateTicketApi.getImmediateTickets(year, month);

      print("immediate response $response");
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
        //?????
        //DialogUtils.showErrorDialog("錯誤","網路異常",context);
        print("Failed to fetch data fetchReservationTicketsData");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isEmpty = true;
      });
      print("error6 $error");
      DialogUtils.showErrorDialog("錯誤","網路異常6",context);
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
                    print('Item at index $index tapped!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImmediateDetailPage(
                            orderNumber: billList[index].id,
                            orderStatus: billList[index].orderStatus,
                          )
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
                            (billList[index].orderStatus == 2) ? 'assets/images/status2and3_icon.png'
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


