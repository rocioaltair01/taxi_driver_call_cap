import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../model/歷史訂單/reservation_ticket_detail_model.dart';
import '../../../model/預約單/reservation_model.dart';
import '../../../respository/預約單/grab_resevation_api.dart';
import '../../../util/dialog_util.dart';

class ReservationViewDetailPage extends StatefulWidget {
  final BillList bill;
  const ReservationViewDetailPage({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  _ReservationViewDetailPageState createState() => _ReservationViewDetailPageState();
}

class _ReservationViewDetailPageState extends State<ReservationViewDetailPage> {
  ReservationTicketDetailModel? ticketDetail;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }


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
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
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
                  style: TextStyle(fontSize: 20),
                ),
              ),
              //Expanded(child: Container()),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    value,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_right,
                size: 32, // 设置图标大小
                color: Colors.blue, // 设置图标颜色
              ),
            ],
          ),
          Divider(
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
        title: Text(
          '訂單細節',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: SpinKitRotatingCircle(
                color: Colors.black,
                size: 80.0,
              )) // Show a loader while data is fetched
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildTable(
              context,
              [
                _buildRow('預約時間', widget.bill.billInfo.reservationTime),
              ],
            ),
            SizedBox(height: 20,),
            _buildTable(
              context,
              [
                _buildRowNextPage('從:',  widget.bill.billInfo.onLocation ?? ''),
                _buildRowNextPage('到:', widget.bill.billInfo.offLocation ?? ''),
                _buildRow('乘客備註:', widget.bill.billInfo.passengerNote ?? ''),
                _buildRow('乘客人數', '${widget.bill.billInfo.userNumber.toString()}位' ?? ''),
              ],
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      GrabReservationApi.grabReservation(widget.bill.billInfo.reservationId);
                    });
                    GlobalDialog.showCustomDialog(
                      context: context, // Pass the context where you want to show the dialog
                      title: '接單成功',
                      message: '',
                      onOkPressed: () {
                        Navigator.pop(context, '完成');
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                    onPrimary: Colors.black,
                  ),
                  child: Text('應徵預約單'),
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}

