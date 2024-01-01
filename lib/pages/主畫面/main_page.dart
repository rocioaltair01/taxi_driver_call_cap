import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/user_data_singleton.dart';
import '../../model/預約單/reservation_model.dart';
import '../../respository/api_service.dart';
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
  LatLng? _currentPosition;

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
    late Timer _timer;

    LatLng location = LatLng(lat, long);
    _currentPosition = location;

    setState(() {
      _currentPosition = location;
      //_isOpen = false;
    });

    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      // 在这里调用你的API
      callAPI();
    });
  }

  void callAPI() async {

    UserData loginResult = UserDataSingleton.instance;

    print('Token get: ${loginResult.token}');

    ApiService apiService = ApiService();

    double latitude = _currentPosition?.latitude ?? 0;
    double longitude = _currentPosition?.longitude ?? 0;
    int plan = 0;
    int status = 1;
    int taxiSort = 0;
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
              ? OfflinePage()
              : OnlinePage(),
        );
      },
    );
  }
}

