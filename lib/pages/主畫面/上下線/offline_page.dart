import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_glad_driver/pages/%E4%B8%BB%E7%95%AB%E9%9D%A2/%E4%B8%8A%E4%B8%8B%E7%B7%9A/offline_count_price_page.dart';

import '../../../model/user_data_singleton.dart';
import '../../../util/dialog_util.dart';
import '../../../util/dialog_util.dart';
import '../main_page.dart';
import '../細節頁/estimate_price.dart';
import '../細節頁/hotspot_page.dart';


class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  @override
  Widget build(BuildContext context) {
    var statusProvider = Provider.of<StatusProvider>(context);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(width: 16,),
                            Container(
                              //padding: EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreenAccent,
                              ),
                              child: const SizedBox(
                                width: 10,
                                height: 10,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '休息中',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ],
                )
            ),
          ],
        ),
        Center(
            child: InkWell(
              onTap: () {
                if (UserDataSingleton.instance.authStatus == 0) {
                  setState(() {
                    statusProvider.updateStatus(GuestStatus.IS_OPEN);
                  });
                } else {
                  DialogUtils.showErrorCenterDialog("目前停權中", context);
                }
              },
              child: Image.asset(
                'assets/images/run.png',
                width: 80,
                height: 80,
              ),
            )
        ),
        Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(height: 50,),
                          Container(height: 20,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EstimatePrice()
                                ),
                              );
                            },
                            child: const Text(
                              '估算金額',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(width: 30,),
                  Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfflineCountPricePage()
                                  ),
                                );
                              },
                              child: const Text(
                                '離線計費',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HotSpotPage()
                                  ),
                                );
                              },
                              child: const Text(
                                '即時熱點',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
