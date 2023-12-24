import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../model/user_data_singleton.dart';
import '../../respository/driver_information_api.dart';


class BasicSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DriverInformationResponse>(
      future: DriverInformationApi.getDriverInformation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCircle(
            color: Colors.black,
            size: 80.0,
          ),);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.data == null) {
          return Center(child: Text('No data available'));
        } else {
          final DriverInformation driverInfo = snapshot.data!.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '基本資料',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffd5d5d5)),
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            const CircleAvatar(
                              radius: 40, // Adjust the size as needed
                              //backgroundImage: AssetImage('assets/images/user.png'), // Replace with your image asset
                            ),
                            Text(
                              driverInfo.result.driverName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                            // Text(
                            //   driverInfo.result.serviceName,
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       fontSize: 18
                            //   ),
                            // ),
                            Text(
                              driverInfo.result.plateNumber,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                            const  SizedBox(height: 20),
                            Container(
                              height: 1,
                              decoration: const BoxDecoration(
                                color: Color(0xffcdcdcd),
                              ),
                            ),
                            Container(
                              height: 60,
                              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '帳號',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    UserDataSingleton.instance.phoneNumber,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  color: Color(0xffcdcdcd),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '密碼',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    '修改密碼',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                      color: Colors.red
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  color: Color(0xffcdcdcd),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '服務',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '照片資料',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBox('Box 1',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 2',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 3',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 4',context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBox('Box 1',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 2',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 3',context),
                          ),
                          Expanded(
                            child: _buildBox('Box 4',context),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          );
        }
      },
    );
  }
}

Widget _buildBox(String text,BuildContext context) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1),
    ),
    height: (MediaQuery.of(context).size.width / 4 - 16 - 8),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/add.png', // Replace with the path to your image
            width: 10, // Adjust the width of the image as needed
            height: 10, // Adjust the height of the image as needed
          ),
        ],
      ),
    ),
  );
}