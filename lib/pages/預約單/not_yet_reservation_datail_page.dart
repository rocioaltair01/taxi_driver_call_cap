import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../model/歷史訂單/reservation_list_model.dart';
import '../../respository/預約單/reservation_grab_ticket_api.dart';
import '../../util/dialog_util.dart';
import 'components/reservation_list_item.dart';
import 'components/reservation_next_list_item.dart';

class NotYetReservationDetailPage extends StatefulWidget {
  final ReservationInfo billData;
  const NotYetReservationDetailPage({
    Key? key,
    required this.billData,
  }) : super(key: key);

  @override
  _NotYetReservationDetailPageState createState() => _NotYetReservationDetailPageState();
}

class _NotYetReservationDetailPageState extends State<NotYetReservationDetailPage> {
  bool isLoading = false;
  String reservationTime = "";
  DateTime? parsedOrderTime;
  String formattedDateOrderTime = "";

  String finishTime = "";
  DateTime? finishTimeTime;
  String formattedFinishTime = "";

  @override
  void initState() {
    super.initState();
    reservationTime = widget.billData.billInfo.reservationTime.toString();
    parsedOrderTime = DateTime.parse(reservationTime).add(Duration(hours: 8));
    formattedDateOrderTime = DateFormat('M-d HH:mm(E)', 'zh').format(parsedOrderTime!);
    formattedDateOrderTime = formattedDateOrderTime.replaceAll("周", "週");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
            ?
        const Center(child: SpinKitFadingCircle(
          color: Colors.black,
          size: 80.0,
        ),) // Show a loader while data is fetched
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTable(
              context,
              [
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '預約時間',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              formattedDateOrderTime,
                              style: const TextStyle(
                                color: Colors.red,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20,),
            _buildTable(
              context,
              [
                ReservationNextListItem(label:'從:', value:widget.billData.billInfo.onLocation ?? '',currentPosition: widget.billData.billInfo.onGps ?? [0,0]),
                ReservationNextListItem(label:'從:', value:widget.billData.billInfo.offLocation ?? '',currentPosition: widget.billData.billInfo.offGps ?? [0,0]),
              ],
            ),
            const SizedBox(height: 20,),
            _buildTable(
              context,
              [
                ReservationListItem(label:'乘客備註:', value:widget.billData.billInfo.passengerNote ?? ''),
                ReservationListItem(label:'乘客人數:', value:'${widget.billData.billInfo.userNumber.toString()}位'),
              ],
            ),
            const SizedBox(height: 60,),
            SizedBox( // Wrap the ElevatedButton in a Container to limit its width
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  ReservationGrabTicketResponse result = await ReservationGrabTicketApi.grabTickets(widget.billData.billInfo.reservationId.toString());
                  if (result.data.success == true)
                  {
                    DialogUtils.showImageDialog("接單成功","ok",context);
                    Navigator.of(context).pop();
                    return;
                  }
                  DialogUtils.showImageDialog("接單失敗","no",context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "應徵預約單",
                    style:
                    TextStyle(
                      color: Colors.black,
                      fontSize: 18, // Set the font size to 40
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

