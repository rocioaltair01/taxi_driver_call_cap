
import 'package:flutter/material.dart';

import 'immediate＿ticket.dart';
import 'reservation_ticket.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor:
              Colors.black.withOpacity(0.6),
              indicatorColor:
              Colors.black,
              tabs: const [
                Tab(
                  child: Text(
                    "立即單",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    "預約單",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const ImmediateTicket(),
            ReservationTicket()
          ],
        ),
      ),
    );
  }
}
