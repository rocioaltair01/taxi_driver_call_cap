import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../model/歷史訂單/reservation_list_model.dart';
import '../../respository/歷史訂單/reservation_ticket_api.dart';
import '../../util/dialog_util.dart';
import 'not_yet_reservation_datail_page.dart';

class NotYetReservation extends StatefulWidget {
  @override
  _NotYetReservationState createState() => _NotYetReservationState();
}

class _NotYetReservationState extends State<NotYetReservation> {
  List<ReservationInfo> billList = [];
  bool isLoading = false;
  bool isEmpty = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    print("hey fetchData");
    try {
      final response = await ReservationTicketApi.getOngoingReservationTickets(false);
      print("hey responsei ${response.data}");
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
        DialogUtils.showErrorDialog("錯誤","網路異常2",context);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isEmpty = true;
        isLoading = false;
      });
      DialogUtils.showErrorDialog("錯誤","網路異常3",context);
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
    return isLoading ? const Center(
      child: SpinKitFadingCircle(
        color: Colors.black,
        size: 80.0,
      ),
    ) : isEmpty ? const Center(
      child: Text(
          "沒有未接預約單",
        style: TextStyle(
            fontSize: 18
        ),
      ),
    ) : ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: billList.length,
      itemBuilder: (BuildContext context, int index) {
        String originalTime = billList[index].billInfo.reservationTime ?? '';
        DateTime parsedTime = DateTime.parse(originalTime).add(const Duration(hours: 8));
        String formattedDate = DateFormat('M-d HH:mm(E)', 'zh').format(parsedTime);
        formattedDate = formattedDate.replaceAll("周", "週");
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotYetReservationDetailPage(
                        billData: billList[index]
                    )
                ),
              ).then((_) {
                fetchData(); // Call when the detail page is popped
              });
            },
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
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
                              '從: ${billList[index].billInfo.onLocation}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '到: ${billList[index].billInfo.offLocation}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '服務備註: ${billList[index].billInfo.passengerNote}',
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '乘客人數: ${billList[index].billInfo.userNumber}人',
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
            )
        );
      },
    );
  }
}


