import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:route_panel/route_panel.dart';

import '../../main.dart';
import '../../model/error_res_model.dart';
import '../../model/user_data_singleton.dart';
import '../../respository/driver_information_api.dart';
import '../../respository/設定/update_password_api.dart';
import '../../respository/設定/update_user_image_api.dart';

class BasicSettingPage extends StatefulWidget {
  const BasicSettingPage({super.key});

  @override
  State<BasicSettingPage> createState() => _BasicSettingPageState();
}

class _BasicSettingPageState extends State<BasicSettingPage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DriverInformationResponse>(
      future: DriverInformationApi.getDriverInformation(
         (res) {
          final jsonData = json.decode(res) as Map<String, dynamic>;
          ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
          GlobalDialog.showAlertDialog(
              context,
              "錯誤",
              responseModel.message
          );
        }
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCircle(
            color: Colors.black,
            size: 80.0,
          ),);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.data == null) {
          return const Center(child: Text('No data available'));
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
                              GestureDetector(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/user.png'),
                                    ),
                                  ),
                                  //radius: 40, // Adjust the size as needed
                                  child: Image.asset(
                                    'assets/images/user.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                    Navigator.push(context, BottomToTopPageRoute(page: TakePictureScreen(type: 'shot',)));
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                driverInfo.result.driverName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                                style: const TextStyle(
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
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
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
                                      style:const  TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Container(
                                  height: 1,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffcdcdcd),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '密碼',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        print("object");
                                        UserData userData = UserDataSingleton.instance;
                                        GlobalDialog().showUpdatePasswordDialog(
                                          context: context,
                                          title: "修改密碼",
                                          onOkPressed: (String newPass,String oldPass, String rewriteNewPass) {
                                            print("ROCIO  ${userData.password}");
                                            print("ROCIO old pass $oldPass");
                                            print("ROCIO newPass pass ${newPass}");
                                          },
                                          onCancelPressed: () {

                                          },
                                        );
                                        UpdatePasswordApi().updatePassword(
                                            "",
                                            (res) {
                                              final jsonData = json.decode(res) as Map<String, dynamic>;
                                              ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
                                              GlobalDialog.showAlertDialog(
                                                  context,
                                                  "錯誤",
                                                  responseModel.message
                                              );
                                            }
                                        );
                                        // UserDataSingleton.reset();
                                        // service.goBack();
                                      },
                                      child: const Text(
                                        '修改密碼',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Container(
                                  height: 1,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffcdcdcd),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                                child: const Row(
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
  return GestureDetector(
    onTap: () {
      Navigator.push(context, BottomToTopPageRoute(page: TakePictureScreen(type: 'info',)));
    },
    child: Container(
      margin: const EdgeInsets.all(8),
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
    ),
  );
}



class TakePictureScreen extends StatefulWidget {
  final String type;

  const TakePictureScreen({
    required this.type,
    super.key,
  });
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('相機'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set your desired border color
                        width: 1.0, // Set your desired border width
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0), // Make it circular
                              ),
                              minimumSize: const Size(50, 50),
                              maximumSize: const Size(50, 50),
                            ),
                            onPressed: () {
                              if (_controller != null)
                              {
                                _controller.takePicture().then((XFile? file) {
                                  if(mounted) {
                                    if(file != null) {
                                      UpdateUserImageApi.updateUserImage(
                                          filePath: file.path,
                                          type: widget.type,
                                          onSuccess: () {
                                            Navigator.pop(context);
                                            GlobalDialog.showAlertDialog(
                                                context,
                                                "成功",
                                                "更新司機資料成功"
                                            );
                                          },
                                          onError: (res) {
                                            final jsonData = json.decode(res) as Map<String, dynamic>;
                                            ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
                                            GlobalDialog.showAlertDialog(
                                                context,
                                                "錯誤",
                                                responseModel.message
                                            );
                                          }
                                      );
                                    }
                                  }
                                });
                              }
                            },
                            child: Container()
                        ),
                      ),
                    ),
                  ),
                ),
            )
          ],
        )
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}