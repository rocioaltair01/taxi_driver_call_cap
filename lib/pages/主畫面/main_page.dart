import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/user_data_singleton.dart';
import '../../model/預約單/reservation_model.dart';
import '../../respository/api_service.dart';
import '上下線/offline_page.dart';
import '上下線/online_page.dart';
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
  BillInfoResevation? bill;
  LatLng? _currentPosition;
  int order_type = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);
    _currentPosition = location;

    setState(() {
      _currentPosition = location;
    });

    UserData loginResult = UserDataSingleton.instance;
    print('Token get: ${loginResult.token}');

    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      callAPI();
    });
  }

  void callAPI() async {
    UserData loginResult = UserDataSingleton.instance;
    ApiService apiService = ApiService();

    double latitude = _currentPosition?.latitude ?? 0;
    double longitude = _currentPosition?.longitude ?? 0;
    int plan = 0;
    int status = 1;
    int taxiSort = 0;

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
      print("ERROR===更新司機位置 error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, statusProvider, _) {
        return Scaffold(
          body:
          (statusProvider.currentStatus == GuestStatus.PREPARED)
              ? PrepareGetPage(bill: bill)
              : (statusProvider.currentStatus == GuestStatus.PICKING_GUEST)
              ? IsPickingQuestPage(bill: bill)
              : (statusProvider.currentStatus == GuestStatus.ARRIVED)
              ? SayIsArrivedPage(bill: bill)
              : statusProvider.currentStatus == GuestStatus.IS_NOT_OPEN
              ? const OfflinePage()
              : const OnlinePage(),
        );
      },
    );
  }
}

