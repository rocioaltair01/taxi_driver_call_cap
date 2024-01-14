import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../util/dialog_util.dart';
import '../../../respository/預約單/reservation_api.dart';
import '../../util/shared_util.dart';
import 'detail_pages/finished_reservation_detail_page.dart';

class FinishedReservationView extends StatefulWidget {
  const FinishedReservationView({super.key});

  @override
  State<FinishedReservationView> createState() => _FinishedReservationViewState();
}

class _FinishedReservationViewState extends State<FinishedReservationView> {
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
      final response = await ReservationApi.getReservationTickets(year, month, 'grabbed');

      if (response.statusCode == 200) {
        if (response.data.isEmpty) {
          setState(() {
            isLoading = false;
            isEmpty = true;
          });
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
    return isLoading // Check if isLoading is true
        ? const Column(
      children: [
        Expanded(
          child: Center(
            child: SpinKitFadingCircle(
              color: Colors.black,
              size: 80.0,
            ),
          ),
        )
      ],
    ) : (isEmpty) ? const Column(
      children: [
        Expanded(
            child: Center(
                child:
                Text(
                  "沒有已接預約單",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinishedReservationViewDetailPage(
                            bill: billList[index])
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '預約時間: ${DateUtil().getDate(billList[index].billInfo.reservationTime)}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '從：${billList[index].billInfo.onLocation}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              (billList[index].billInfo.offLocation == null ||
                                  billList[index].billInfo.offLocation == "") ?
                              '到: 無上車地點' :
                              '到: ${billList[index].billInfo.offLocation}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '服務備註: ${billList[index].billInfo.passengerNote}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '乘客人數: ${billList[index].billInfo.userNumber}人',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 1,
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
