import 'package:flutter/material.dart';
import '../../model/歷史訂單/immediate_ticket_detail_model.dart';
import '../../respository/歷史訂單/immediate_ticket_detail_api.dart';
import 'components/history_list_item.dart';
import 'components/history_next_list_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class ImmediateDetailPage extends StatefulWidget {
  final int orderNumber;
  final int orderStatus;
  const ImmediateDetailPage({
    Key? key,
    required this.orderNumber,
    required this.orderStatus,
  }) : super(key: key);

  @override
  _ImmediateDetailPageState createState() => _ImmediateDetailPageState();
}

class _ImmediateDetailPageState extends State<ImmediateDetailPage> {
  ImmediateTicketDetailModel? ticketDetail;
  bool isLoading = false;
  String orderTime = "";
  DateTime? parsedOrderTime;
  String formattedDateOrderTime = "";

  String finishTime = "";
  DateTime? finishTimeTime;
  String formattedFinishTime = "";

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
      final response = await ImmediateTicketDetailApi.getImmediateTicketDetail(widget.orderNumber);

      if (response.statusCode == 200) {
        setState(() {
          ticketDetail = response.data;
          if (ticketDetail != null)
          {
            orderTime = ticketDetail!.orderTime.toString();
            parsedOrderTime = DateTime.parse(orderTime).add(Duration(hours: 8));
            formattedDateOrderTime = DateFormat('M-d HH:mm(E)', 'zh').format(parsedOrderTime!);
            formattedDateOrderTime = formattedDateOrderTime.replaceAll("周", "週");
            finishTime = ticketDetail!.finishTime.toString();
            finishTimeTime = DateTime.parse(finishTime).add(Duration(hours: 8));
            formattedFinishTime = DateFormat('M-d HH:mm(E)', 'zh').format(finishTimeTime!);
            formattedFinishTime = formattedFinishTime.replaceAll("周", "週");
          }
          isLoading = false;
        });
      } else {
        print("response.statusCode${response.statusCode}");
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
      body: isLoading ?
      const Center(child: SpinKitFadingCircle(
        color: Colors.black,
        size: 80.0,
      ),) // Show a loader while data is fetched
       : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ticketDetail != null)
                _buildTable(
                  context,
                  [
                    HistoryListItem(label:'接單時間', value:formattedDateOrderTime),
                    HistoryListItem(label:'完成時間', value:formattedFinishTime),
                    HistoryListItem(label:'單號',
                      value:(widget.orderStatus == 0) ? '${ticketDetail!.id.toString()} ' : '${ticketDetail!.id.toString()}',
                      twoValue:true,statusValue: widget.orderStatus,),
                    HistoryListItem(label:'付款方式', value:'現金付款'),
                  ],
                ),
              const SizedBox(height: 20,),
              if (ticketDetail != null)
                _buildTable(
                  context,
                  [
                    HistoryNextListItem(label:'從:', value:ticketDetail!.onLocation ?? '',currentPosition: ticketDetail!.onGps!),
                    HistoryNextListItem(label:'到:',value:(ticketDetail!.offLocation == null || ticketDetail!.offLocation == '') ? '此乘客無提供下車地點' : ticketDetail!.offLocation.toString(), currentPosition: ticketDetail!.onGps!),
                    HistoryListItem(label:'乘客人數', value:'1位'),
                    HistoryListItem(label:'乘客備註:', value:ticketDetail!.passengerNote ?? ''),
                    HistoryListItem(label:'里程數:', value:'${ticketDetail!.milage}(公里)'),
                    HistoryListItem(label:'分鐘:', value:'  ${((ticketDetail!.routeSecond ?? 0)/60).toStringAsFixed(1)}(分鐘)'),
                    HistoryListItem(label:'金額:', value:'＄${ticketDetail!.actualPrice.toString()}' ?? ''),
                    // ... Add more fields from the ticket detail model
                  ],
                ),
            ],
          ),
        ),
      )
    );
  }
}

