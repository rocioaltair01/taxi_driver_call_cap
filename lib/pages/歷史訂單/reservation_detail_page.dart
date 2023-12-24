import 'package:flutter/material.dart';
import '../../model/歷史訂單/reservation_ticket_detail_model.dart';
import '../../respository/歷史訂單/reservation_ticket_detail_api.dart';
import 'components/history_list_item.dart';
import 'components/history_next_list_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ReservationDetailPage extends StatefulWidget {
  final int orderNumber;
  final int orderStatus;
  const ReservationDetailPage({
    Key? key,
    required this.orderNumber,
    required this.orderStatus,
  }) : super(key: key);

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  ReservationTicketDetailModel? ticketDetail;
  bool isLoading = false;
  String reservationTime = "";
  DateTime? parsedOrderTime;
  String formattedDateOrderTime = "";


  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ReservationTicketDetailApi.getReservationTicketDetail(widget.orderNumber);

      if (response.statusCode == 200) {
        setState(() {
          ticketDetail = response.data;
          reservationTime = ticketDetail!.billInfo.reservationTime!.toString();
          parsedOrderTime = DateTime.parse(reservationTime).add(Duration(hours: 8));
          formattedDateOrderTime = DateFormat('M-d HH:mm(E)', 'zh').format(parsedOrderTime!);

          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $error');
    }
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
        child:
        isLoading
            ?
        const Center(child: SpinKitFadingCircle(
          color: Colors.black,
          size: 80.0,
        )) // Show a loader while data is fetched
            :
        Column(
          children: [
            if (ticketDetail != null)
              _buildTable(
                context,
                [
                 HistoryListItem(label:'預約時間', value: formattedDateOrderTime),
                 HistoryListItem(label:'單號', value: ticketDetail!.billInfo.orderId.toString(), twoValue: true,statusValue: widget.orderStatus),
                 const HistoryListItem(label:'付款方式', value: '現金付款'),
                ],
              ),
            const SizedBox(height: 20,),
            if (ticketDetail != null)
              _buildTable(
                context,
                [
                  HistoryNextListItem(label:'從:', value: ticketDetail!.billInfo.onLocation ?? '', currentPosition: ticketDetail!.billInfo.onGps ?? [0,0],),
                  HistoryNextListItem(label:'到:', value: (ticketDetail!.billInfo.offLocation == null || ticketDetail!.billInfo.offLocation == '')
                      ? '此乘客無提供下車地點' : ticketDetail!.billInfo.offLocation.toString(), currentPosition: ticketDetail!.billInfo.offGps ?? [0,0],),
                  HistoryListItem(label:'乘客人數', value: '${ticketDetail!.billInfo.userNumber.toString()}位' ?? ''),
                  HistoryListItem(label:'乘客備註:', value: ticketDetail!.billInfo.passengerNote ?? ''),
                  HistoryListItem(label:'里程數:', value: '${ticketDetail!.billInfo.milage.toString()}(公里)' ?? ''),
                  HistoryListItem(label:'分鐘:', value: '${ticketDetail!.billInfo.routeSecond.toString()}(分鐘)' ?? ''),
                  HistoryListItem(label:'金額:', value: '＄${ticketDetail!.billInfo.actualPrice}' ?? ''),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
