import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/error_res_model.dart';
import '../../../model/歷史訂單/immediate_ticket_detail_model.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/歷史訂單/immediate_ticket_detail_api.dart';
import '../../../util/dialog_util.dart';
import '../main_page.dart';

class GrabSuccessPage extends StatefulWidget {
  final int orderId;
  final double selectedTime;
  const GrabSuccessPage({
    super.key,
    required this.orderId,
    required this.selectedTime,
  });

  @override
  State<GrabSuccessPage> createState() => _GrabSuccessPageState();
}

class _GrabSuccessPageState extends State<GrabSuccessPage> {
  ImmediateTicketDetailModel? ticketDetail;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (mounted)
      {
        setState(() {
          isLoading = true;
        });
      }
    try {
      final response = await ImmediateTicketDetailApi.getImmediateTicketDetail(
          widget.orderId,
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
        if (mounted) {
          setState(() {
            ticketDetail = response.data;
            // if (ticketDetail != null)
            // {
            //   //orderTime = ticketDetail!.orderTime.toString();
            // }
            isLoading = false;
          });
        }

      } else {
        print("@=== getImmediateTicketDetail Failed response.statusCode ${response.statusCode}");
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("@=== getImmediateTicketDetail Failed");
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: Container()),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/grab_success.png',
                  width: 120,
                  height: 120,
                ),
                Text("上車地點：${ticketDetail?.onLocation}"),
                Text("訂單備註：${ticketDetail?.passengerNote}"),
                const Text("搶單成功"),
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
              padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                ),
                minimumSize: const Size(double.infinity, 50), // Set the button height
              ),
              onPressed: () async{
                Navigator.pop(context);
                StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                statusProvider.updateStatus(GuestStatus.PREPARED);

                mainPageKey.currentState?.order_type = 0;
                mainPageKey.currentState?.bill = BillInfoResevation(
                  driverId: null,
                  orderStatus: ticketDetail?.orderStatus ?? 0,
                  reservationId: widget.orderId,
                  onLocation: ticketDetail?.onLocation ?? "",
                  offLocation: ticketDetail?.offLocation ?? "",
                  reservationType: "",
                  reservationTime: "",
                  passengerNote: ticketDetail?.passengerNote ?? "",
                  onGps: ticketDetail?.onGps ?? [],
                  offGps: ticketDetail?.offGps ?? [],
                  userNumber: ticketDetail?.userNumber ?? 0,
                  acknowledgingOrderMethods: 0,
                  serviceList: "",
                  reservationTeam: "",
                  blacklist: "",
                  createdAt: "",
                  clickMeterDate: null,
                  getInTime: widget.selectedTime,
                  getPassengerTime: null,
                  passengerOnLocationNote: "",
                  isDeal: "",
                );
              },
              child: const Text(
                '前往載客',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60,)
        ],
      ),
    );
  }
}
