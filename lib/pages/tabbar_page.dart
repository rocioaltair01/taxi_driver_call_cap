import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:untitled1/respository/api_service.dart';

import '../model/user_data_singleton.dart';
import '主畫面/main_page.dart';
import '客服/chat_page.dart';
import '歷史訂單/history_page.dart';
import '設定/setting_page.dart';
import '預約單/reservation_page.dart';

class TabbarPage extends StatefulWidget {

  const TabbarPage({Key? key}) : super(key: key);

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  int pageIndex = 2;
  late Timer _timer;

  late List<Widget> pages;


  @override
  void initState() {
    super.initState();
    pages = [
      const HistoryPage(),
      const ReservationPage(),
      const MainPage(),
      SettingPage(),
      //const SettingPage(),
     ChatPage(),
    ];
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      // 在这里调用你的API
      callAPI();
    });
  }

  void callAPI() async {

    UserData loginResult = UserDataSingleton.instance;

    print('Token: ${loginResult.token}');

    ApiService apiService = ApiService();

    double latitude = 1.0;
    double longitude = 1.0;
    int plan = 1;
    int status = 1;
    int taxiSort = 1;
// Trigger driver's GPS update
    try {
      await apiService.triggerDriverGps(
          latitude,
          longitude,
          plan,
          status,
          taxiSort,
          loginResult.token
      );
    } catch (error) {
      // Handle error accordingly (show message, retry logic, etc.)
    }
    // // 这里是调用API的逻辑
    // try {
    //   var response = await http.get(Uri.parse('https://your-api-endpoint.com'));
    //   // 处理响应...
    //   print('API called at ${DateTime.now()}');
    // } catch (e) {
    //   print('Error calling API: $e');
    // }
  }

  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
  final _tab4navigatorKey = GlobalKey<NavigatorState>();
  final _tab5navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //print("loginNavigatorKey3${widget.loginNavigatorKey.currentState}");
    return ChangeNotifierProvider(
        create: (context) => StatusProvider(),
        child: PersistentBottomBarScaffold(
          items: [
            PersistentTabItem(
              tab: pages[0],
              icon: Image.asset(
                'assets/images/main.png',
                width: 20,
                height: 20,
              ),
              title: 'Home',
              navigatorkey: _tab1navigatorKey,
            ),
            PersistentTabItem(
              tab: pages[1],
              icon: Image.asset(
                'assets/images/main.png',
                width: 20,
                height: 20,
              ),
              title: 'Search',
              navigatorkey: _tab2navigatorKey,
            ),
            PersistentTabItem(
              tab: pages[2],
              icon: Image.asset(
                'assets/images/main.png',
                width: 20,
                height: 20,
              ),
              title: 'Profile',
              navigatorkey: _tab3navigatorKey,
            ),
            PersistentTabItem(
              tab: pages[3],
              icon: Image.asset(
                'assets/images/main.png',
                width: 20,
                height: 20,
              ),
              title: 'Search',
              navigatorkey: _tab4navigatorKey,
            ),
            PersistentTabItem(
              tab: pages[4],
              icon: Image.asset(
                'assets/images/main.png',
                width: 20,
                height: 20,
              ),
              title: 'Profile',
              navigatorkey: _tab5navigatorKey,
            ),
          ],
        )
    );

  }
}

class PersistentBottomBarScaffold extends StatefulWidget {
  final List<PersistentTabItem> items;


  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);


  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}


class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 2;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedTab,
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
        if (index == _selectedTab) {
          /// if you want to pop the current tab to its root then use
          widget.items[index].navigatorkey?.currentState
              ?.popUntil((route) => route.isFirst);


          /// if you want to pop the current tab to its last page
          /// then use
          // widget.items[index].navigatorkey?.currentState?.pop();
        } else {
          setState(() {
            _selectedTab = index;
          });
        }
      },
      child: Container(
        width: itemWidth, // Adjust the width as needed
        child: Column(
          children: [
            _selectedTab == index
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

