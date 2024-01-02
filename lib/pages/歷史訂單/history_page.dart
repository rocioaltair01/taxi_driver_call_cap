
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
      length: 2, // Adjust the number of tabs as needed
      child: Scaffold(
        appBar: AppBar(
          elevation: 0, // Set the elevation to 0 to remove the shadow
          toolbarHeight: 0,
          backgroundColor: Colors.white, // Set the background color of the AppBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0), // Set the height of the TabBar
            child: TabBar(
              labelColor: Colors.black, // Set the color of the selected tab text
              unselectedLabelColor:
              Colors.black.withOpacity(0.6), // Set the color of unselected tab text
              indicatorColor:
              Colors.black, // Set the color of the selected tab indicator
              tabs: const [
                Tab(
                  child: Text(
                    "立即單",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
                  ),
                ),
                Tab(
                  child: Text(
                    "預約單",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
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
