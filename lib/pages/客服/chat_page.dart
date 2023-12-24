import 'package:flutter/material.dart';

import 'views/message_view_page.dart';
import 'views/post_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

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
              tabs: [
                Tab(
                  child: Text(
                    "客服訊息",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
                  ),
                ),
                Tab(
                  child: Text(
                    "公告",
                    style: TextStyle(fontSize: 18), // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MessagePageView(),
            PostView(),
          ],
        ),
      ),
    );
  }
}

