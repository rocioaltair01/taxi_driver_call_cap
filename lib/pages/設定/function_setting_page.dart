import 'package:flutter/material.dart';

import '../../model/user_data_singleton.dart';
import '../../respository/navigation_service.dart';


class FunctionSettingPage extends StatefulWidget {
  const FunctionSettingPage({Key? key}) : super(key: key);

  @override
  State<FunctionSettingPage> createState() => _FunctionSettingPageState();
}

class _FunctionSettingPageState extends State<FunctionSettingPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    NavigationService service = NavigationService();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text("功能設定",style: TextStyle(
              fontSize: 18
          ),),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Set the border color
              width: 1.0, // Set the border width
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("預約接收提醒",style: TextStyle(
                          fontSize: 16
                      ),)
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        UserDataSingleton.reset();
                        service.goBack();
                      },
                      child: const Text(
                        '帳號登出',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}


