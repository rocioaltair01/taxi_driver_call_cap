import 'package:flutter/material.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  final List<PersistentTabItem> items;


  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);


  @override
  PersistentBottomBarScaffoldState createState() =>
      PersistentBottomBarScaffoldState();
}


class PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int selectedTab = 2;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.items[selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: widget.items
              .map((page) => Navigator(
            key: page.navigatorkey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.tab)
              ];
            },
          ))
              .toList(),
        ),
        bottomNavigationBar: buildMyNavBar(context),
      ),
    );
  }

  Widget buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(0, 'assets/images/tabs/history.png', 'assets/images/tabs/history_s.png', '歷史訂單'),
          buildNavItem(1, 'assets/images/tabs/reservation.png', 'assets/images/tabs/reservation_s.png', '正在進行的預約單'),
          buildNavItem(2, 'assets/images/tabs/main.png', 'assets/images/tabs/main_s.png', '主畫面'),
          buildNavItem(3, 'assets/images/tabs/setting.png', 'assets/images/tabs/setting_s.png', '設定'),
          buildNavItem(4, 'assets/images/tabs/message.png', 'assets/images/tabs/message_s.png', '客服'),
        ],
      ),
    );
  }

  Widget buildNavItem(int index, String filledIcon, String outlinedIcon, String label, {bool isWide = false}) {
    double itemWidth = MediaQuery.of(context).size.width / 5;
    return InkWell(
      onTap: () {
        //     /// Check if the tab that the user is pressing is currently selected
        if (index == selectedTab) {
          /// if you want to pop the current tab to its root then use
          widget.items[index].navigatorkey?.currentState
              ?.popUntil((route) => route.isFirst);


          /// if you want to pop the current tab to its last page
          /// then use
          // widget.items[index].navigatorkey?.currentState?.pop();
        } else {
          setState(() {
            selectedTab = index;
          });
        }
      },
      child: Container(
        width: itemWidth, // Adjust the width as needed
        child: Column(
          children: [
            selectedTab == index
                ? Image.asset(
              outlinedIcon,
              width: 30,
              height: 30,
            )
                : Image.asset(
              filledIcon,
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final Image icon;

  PersistentTabItem(
      {
        required this.tab,
        this.navigatorkey,
        required this.title,
        required this.icon
      });
}

//https://www.linkedin.com/pulse/persistent-bottom-navigation-bar-flutter-lakshydeep-vikram-sah/

