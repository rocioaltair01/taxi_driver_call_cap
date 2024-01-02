import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../model/user_data_singleton.dart';
import '主畫面/main_page.dart';
import '主畫面/tabbar/persistent_bottom_bar_scaffold.dart';
import '客服/chat_page.dart';
import '歷史訂單/history_page.dart';
import '設定/setting_page.dart';
import '預約單/reservation_page.dart';

final GlobalKey<PersistentBottomBarScaffoldState> pertabbarPageKey = GlobalKey<PersistentBottomBarScaffoldState>();

class TabbarPage extends StatefulWidget {

  const TabbarPage({Key? key}) : super(key: key);

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> with WidgetsBindingObserver {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    pages = [
      const HistoryPage(),
      const ReservationPage(),
      MainPage(
        key: mainPageKey,
      ),
      SettingPage(),
      ChatPage(),
    ];
    // _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
    //   // 在这里调用你的API
    //   callAPI();
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        UserDataSingleton.reset();
        print("AppLifecycleState detached");
        break;
      case AppLifecycleState.hidden:
        break;
    }
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
          key: pertabbarPageKey,
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
