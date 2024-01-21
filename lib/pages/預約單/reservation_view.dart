import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../respository/預約單/reservation_api.dart';
import 'package:intl/intl.dart';

import 'detail_pages/reservation_view_detail_page.dart';

class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  @override
  State<ReservationView> createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  List<BillList> billList = [];
  List<int> colorCodes = [];
  int year = 2023;
  int month = 12;
  bool isLoading = false;
  bool isEmpty = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ReservationApi.getReservationTickets(year, month, 'ungrabbed');

      if (response.statusCode == 200) {
        if (response.data.isEmpty) {
          if (mounted) {
            setState(() {
              isLoading = false;
              isEmpty = true;
            });
          }
        } else {
          isEmpty = false;
          setState(() {
            billList = response.data;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to fetch data');
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Column(
      children: [
        Expanded(
          child: Center(
            child: SpinKitFadingCircle(
              color: Colors.black,
              size: 80.0,
            ),
          ),
        ),
      ],
    ) : (isEmpty) ? const Column(
      children: [
        Expanded(
            child: Center(
                child: Text(
                  "沒有未接預約單",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
            )
        ),
      ],
    ) : Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: billList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationViewDetailPage(
                          bill: billList[index])
                    ),
                  );
                  await fetchData();
                },
                child: Container(
                  //color: Colors.red,
                  child: Row(
                    children: [
                      Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '預約時間：${getDate(billList[index].billInfo.reservationTime)}',
                                  overflow: TextOverflow.clip, // Handle long text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // You can add more styles like fontWeight, color, etc. as needed
                                  ),
                                ),
                                Text(
                                  '從：${billList[index].billInfo.onLocation}',
                                  overflow: TextOverflow.clip, // Handle long text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // You can add more styles like fontWeight, color, etc. as needed
                                  ),
                                ),
                                Text(
                                  '到: ${billList[index].billInfo.offLocation}',
                                  overflow: TextOverflow.clip, // Handle long text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // You can add more styles like fontWeight, color, etc. as needed
                                  ),
                                ),
                                Text(
                                  '服務備註: ${billList[index].billInfo.passengerNote}',
                                  overflow: TextOverflow.clip, // Handle long text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // You can add more styles like fontWeight, color, etc. as needed
                                  ),
                                ),
                                Text(
                                  '乘客人數: ${billList[index].billInfo.userNumber.toString()}人',
                                  overflow: TextOverflow.clip, // Handle long text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // You can add more styles like fontWeight, color, etc. as needed
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
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
    );
  }

  String getDate(String dateString)
  {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('MM-dd HH:mm (E)').format(dateTime.toLocal());
    return formattedDate;
  }
}
