
import 'package:flutter/material.dart';
import 'basic_settings.dart';
import 'function_setting_page.dart';
import 'statistic_setting_page.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: "基本設定"),
                Tab(text: "功能設定"),
                Tab(text: "月統計表"),
              ],
              labelStyle: const TextStyle(fontSize: 18),
              unselectedLabelStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            BasicSettingPage(),
            FunctionSettingPage(),
            StatisticSettingPage()
          ],
        ),
      ),
    );
  }
}
