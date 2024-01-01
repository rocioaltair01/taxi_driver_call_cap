import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../model/預約單/reservation_model.dart';
import '../../../util/dialog_util.dart';
import '../../tabbar_page.dart';
import '../../主畫面/main_page.dart';

class FinishedReservationViewDetailPage extends StatefulWidget {
  final BillList bill;
  const FinishedReservationViewDetailPage({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  _FinishedReservationViewDetailPageState createState() => _FinishedReservationViewDetailPageState();
}

class _FinishedReservationViewDetailPageState extends State<FinishedReservationViewDetailPage> {
  bool isLoading = false;

  Widget _buildTable(BuildContext context, List<Widget> rows) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                value,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
        ),
      ],
    );
  }

  Widget _buildRowNextPage(String label, String value) {
    return GestureDetector(
      onTap: () {

      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              //Expanded(child: Container()),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    value,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/arrow_right.png',
                width: 30,
                height: 30,
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '訂單細節',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: SpinKitFadingCircle(
              color: Colors.black,
              size: 80.0,
            )) // Show a loader while data is fetched
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildTable(
              context,
              [
                _buildRow('預約時間', DateUtil().getDate(widget.bill.billInfo.reservationTime)),
                _buildRow('單號', widget.bill.billInfo.reservationId.toString()),
                _buildRow('付款方式', '現金付款'),
              ],
            ),
            const SizedBox(height: 20,),
            _buildTable(
              context,
              [
                _buildRowNextPage('從:',  widget.bill.billInfo.onLocation ?? ''),
                _buildRowNextPage('到:', widget.bill.billInfo.offLocation ?? ''),
                _buildRow('乘客備註:', widget.bill.billInfo.passengerNote ?? ''),
                _buildRow('乘客人數', '${widget.bill.billInfo.userNumber.toString()}位' ?? ''),
              ],
            ),
            const SizedBox(height: 40,),
            (widget.bill.billInfo.orderStatus == 3) ?
             Center(
               child:Column(
                 children: [
                   Image.asset(
                     'assets/images/ok.png',
                     width: 120,
                     height: 120,
                   ),
                   const Text(
                       "已完成",
                     style: TextStyle(
                       fontSize: 22,
                       color: Colors.green,
                     ),
                   )
                 ],
               )
             ) : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      pertabbarPageKey.currentState?.setState(() {
                        pertabbarPageKey.currentState?.selectedTab = 2;
                      });
                      print("ROICO widget.bill ${widget.bill}");
                      print("ROCIO ${mainPageKey.currentState}");
                      print("ROCIOmainPageKey.currentState?.bill ${mainPageKey.currentState?.bill}");
                      mainPageKey.currentState?.bill = widget.bill;
                      print("ROCIOmainPageKey.currentState?.bill ${mainPageKey.currentState?.bill}");
                      StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                      statusProvider.updateStatus(GuestStatus.PREPARED);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      onPrimary: Colors.black,
                    ),
                    child: const Text('準備載客'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

