
import 'package:flutter/material.dart';

import 'finished_reservation_page.dart';
import 'not_yet_reservation_page.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

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
            preferredSize: Size.fromHeight(48.0), // Set the height of the TabBar
            child: TabBar(
              labelColor: Colors.black, // Set the color of the selected tab text
              unselectedLabelColor:
              Colors.black.withOpacity(0.6), // Set the color of unselected tab text
              indicatorColor:
              Colors.black, // Set the color of the selected tab indicator
              tabs: const [
                Tab(
                  child: Text(
                    "未接預約",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
                  ),
                ),
                Tab(
                  child: Text(
                    "已接預約單",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            NotYetReservation(),
            FinishedReservation()
          ],
        ),
      ),
    );
  }
}
