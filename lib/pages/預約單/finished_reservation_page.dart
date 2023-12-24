import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../model/歷史訂單/reservation_list_model.dart';
import '../../respository/歷史訂單/reservation_ticket_api.dart';
import '../../util/dialog_util.dart';
import '../歷史訂單/immediate_detail_page.dart';

class FinishedReservation extends StatefulWidget {
  @override
  _FinishedReservationState createState() => _FinishedReservationState();
}

class _FinishedReservationState extends State<FinishedReservation> {
  List<ReservationInfo> billList = [];
  bool isLoading = false;
  bool isEmpty = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    print("hey fetchData");
    try {
      final response = await ReservationTicketApi.getOngoingReservationTickets(true);
      print("hey response ${response.data}");
      if (response.statusCode == 200) {
        if (response.data.isEmpty) {
          setState(() {
            isLoading = false;
            isEmpty = true;
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
    ) : isEmpty ? const Center(child: Text(
        "沒有已接預約單",
        style: TextStyle(
        fontSize: 18
      ),
    ),)
        : ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: billList.length,
      itemBuilder: (BuildContext context, int index) {
        String originalTime = billList[index].billInfo.reservationTime ?? '';
        DateTime parsedTime = DateTime.parse(originalTime).add(Duration(hours: 8));
        String formattedDate = DateFormat('M-d HH:mm(週E)', 'zh').format(parsedTime);
        return GestureDetector(
            onTap: () {
              print('Item at index $index tapped!');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImmediateDetailPage(
                      orderNumber: billList[index].billInfo.reservationId ?? 0,
                      orderStatus: 3,
                    )
                ),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/distribute.png',
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
                            '從: ${billList[index].billInfo.onLocation}',
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '備註: ${billList[index].billInfo.passengerNote}',
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
            )
        );
      },
    );
  }
}


