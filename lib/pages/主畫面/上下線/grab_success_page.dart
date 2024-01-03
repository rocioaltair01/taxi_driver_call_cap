import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tabbar_page.dart';
import '../main_page.dart';

class GrabSuccessPage extends StatefulWidget {
  const GrabSuccessPage({super.key});

  @override
  State<GrabSuccessPage> createState() => _GrabSuccessPageState();
}

class _GrabSuccessPageState extends State<GrabSuccessPage> {
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
                Text("搶單成功"),
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
              padding: EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                ),
                minimumSize: const Size(double.infinity, 50), // Set the button height
              ),
              onPressed: () {
                Navigator.pop(context);
                pertabbarPageKey.currentState?.setState(() {
                  pertabbarPageKey.currentState?.selectedTab = 2;
                });
                //mainPageKey.currentState?.bill = widget.bill;
                StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);
                statusProvider.updateStatus(GuestStatus.PREPARED);
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
          SizedBox(height: 60,)
        ],
      ),
    );
  }
}
