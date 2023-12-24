import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/預約單/reservation_model.dart';
import 'offline_page.dart';
import 'online_page.dart';
import '開始載客/is_picking_guest.dart';
import '開始載客/prepare_get_page.dart';
import '開始載客/say_is_arrived.dart';

final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();

enum GuestStatus {
  PREPARED, //狀態1
  ARRIVED,// 點選到達定點
  PICKING_GUEST,// 結束載客
  IS_OPEN,
  IS_NOT_OPEN
}

class StatusProvider with ChangeNotifier {
  GuestStatus _currentStatus = GuestStatus.IS_NOT_OPEN;

  GuestStatus get currentStatus => _currentStatus;

  void updateStatus(GuestStatus newStatus) {
    _currentStatus = newStatus;
    notifyListeners();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String pick_status = "前往載客中";
  // GuestStatus current_status = GuestStatus.IS_NOT_OPEN;
  BillList? bill;

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, statusProvider, _) {
        return Scaffold(
          body:
          (statusProvider.currentStatus == GuestStatus.PREPARED)
              ? PrepareGetPage(bill: bill!)
              : (statusProvider.currentStatus == GuestStatus.PICKING_GUEST)
              ? IsPickingQuestPage(bill: bill!)
              : (statusProvider.currentStatus == GuestStatus.ARRIVED)
              ? SayIsArrivedPage(bill: bill!)
              : statusProvider.currentStatus == GuestStatus.IS_NOT_OPEN
              ? OfflinePage()
              : OnlinePage(),
        );
      },
    );
  }
}

