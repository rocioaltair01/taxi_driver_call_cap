import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_glad_driver/model/user_data_singleton.dart';

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
    try {
      final response = await ReservationTicketApi.getOngoingReservationTickets(false);
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
        DialogUtils.showErrorDialog("錯誤","網路異常",context);
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isEmpty = true;
        isLoading = false;
      });
      DialogUtils.showErrorDialog("錯誤","網路異常",context);
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
              if (UserDataSingleton.instance.authStatus == 0) {
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
              } else {
                DialogUtils.showErrorCenterDialog("目前停權中", context);
              }
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
                              "預約時間: $formattedDate",
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 18,
                              ),// Handle long text
                            ),
                            Text(
                              '從: ${billList[index].billInfo.onLocation}',
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


