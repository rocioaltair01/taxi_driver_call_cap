import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../respository/設定/statistics_api.dart';
import '../../util/dialog_util.dart';
import '../歷史訂單/components/date_header.dart';
import 'components/statistic_item.dart';

class StatisticSettingPage extends StatefulWidget {
  const StatisticSettingPage({Key? key}) : super(key: key);

  @override
  State<StatisticSettingPage> createState() => _StatisticSettingPageState();
}

class _StatisticSettingPageState extends State<StatisticSettingPage> {
  DateTime now = DateTime.now();
  int year = 2023;
  int month = 8;
  FixedExtentScrollController _dateYearController =
  FixedExtentScrollController(initialItem: 2);
  FixedExtentScrollController _dateMonthController =
  FixedExtentScrollController(initialItem: 2);

  StatisticsData? statisticsData;
  bool isLoading = false;

  List<String> monthNamesInChinese = [
    "一月", "二月", "三月", "四月", "五月", "六月",
    "七月", "八月", "九月", "十月", "十一月", "十二月"
  ];

  List<String> yearNamesInChinese = [
    "2000年", "2001年", "2002年", "2003年", "2004年", "2005年", "2006年", "2007年",
    "2008年", "2009年", "2010年", "2011年", "2012年", "2013年", "2014年", "2015年",
    "2016年", "2017年", "2018年", "2019年", "2020年", "2021年", "2022年", "2023年"
  ];

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await StatisticsApi.getStatistics(year, month);

      if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
            statisticsData = response.data?.result;
          });
      } else {
        setState(() {
          isLoading = false;
        });
        DialogUtils.showErrorDialog("錯誤","網路異常8",context);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      DialogUtils.showErrorDialog("錯誤","網路異常9",context);
      throw Exception('Error: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    int selectedYear = year;
    int selectedMonth = month;

    final picked = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
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
                              style: TextStyle(fontSize: 22.0),
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
                              style: TextStyle(fontSize: 22.0),
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
                    minimumSize: Size(double.infinity, 48), // 宽度填充并设置高度
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
      await fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    year = now.year;
    month = now.month;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: SpinKitFadingCircle(
      color: Colors.black,
      size: 80.0,
    ),)
        : SingleChildScrollView(
      child: Column(
        children: [
          DateHeader(
            year: year,
            month: month,
            onPressed: () {
              //Navigator.pop(context);
              _selectDate(context);
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "立即單",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      StatisticItem(
                        title: "接單數",
                        content: statisticsData?.transactionCount.toString() ?? '0',
                      ),
                      StatisticItem(
                          title: "成功數",
                          content: statisticsData?.transactionSuccessCount.toString() ?? '0'
                      ),
                      StatisticItem(
                        title: "成功率",
                        content: (statisticsData?.transactionSuccessCount == 0 && statisticsData?.transactionCount == 0) ? '0%'
                            : '${((statisticsData?.transactionSuccessCount ?? 0)/ (statisticsData?.transactionCount ?? 0)*100).toString()}%',
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("預約單",style: TextStyle(
                      fontSize: 18
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    // 2
                    children: [
                      StatisticItem(
                        title: "接單數",
                        content: statisticsData?.reservationCount.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "成功數",
                        content: statisticsData?.reservationSuccessCount.toString() ?? '0',
                      ),
                      StatisticItem(
                          title: "成功率",
                          content: (statisticsData?.reservationSuccessCount == 0 && statisticsData?.reservationCount == 0) ? '0%' :
                          "${((statisticsData?.reservationSuccessCount ?? 0)/(statisticsData?.reservationCount ?? 0)*100).toString()}%"
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("特約商家",style: TextStyle(
                      fontSize: 18
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      StatisticItem(
                        title: "接單數",
                        content: statisticsData?.storeOrderNumber.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "成功數",
                        content: statisticsData?.storeOrderSuccess.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "成功率",
                        content: (statisticsData?.storeOrderNumber == 0 && statisticsData?.storeOrderSuccess == 0) ? '0%'
                            : '${((statisticsData?.storeOrderSuccess ?? 0)/(statisticsData?.storeOrderNumber ?? 0)*100).toString()}%',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      StatisticItem(
                        title: "累積回饋金  (一個月)",
                        content: statisticsData?.storeTotalRebate.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "營業總金額",
                        content: statisticsData?.revenue.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "月費",
                        content: statisticsData?.monthFare.toString() ?? '0',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      StatisticItem(
                        title: "後結",
                        content: statisticsData?.afterPayFare.toString() ?? '0',
                      ),
                      StatisticItem(
                        title: "最後給的費用",
                        content: statisticsData?.finalFee.toString() ?? '0',
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

