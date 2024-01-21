import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/error_res_model.dart';
import '../model/user_data_singleton.dart';
import '../respository/設定/update_password_api.dart';

class GlobalDialog {
  static void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: Container(
            width: double.infinity,
            height: 350,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0), // Set border radius
              border: Border.all(color: Colors.black), // Add border
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                      fontSize: 26
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      message,
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      '確定',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showPaymentDialog(
      BuildContext context,
      String title,
      String price,
      String distance,
      Function() onOkPressed,
      Function() onCancelPressed,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: Container(
            height: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0), // Set border radius
              border: Border.all(color: Colors.black), // Add border
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "金額: $price 元",
                    style: const TextStyle(
                        fontSize: 22
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "里程數: ${distance} 公里",
                    style: const TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.grey
                        ),
                        onPressed: () {
                          onCancelPressed();
                          Navigator.of(context).pop();// Call the function when '確定' button is pressed
                          // Navigator.of(context).pop();
                        },
                        child: const Text(
                          '取消',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          onOkPressed();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '結帳',
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Function() onOkPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const  Size(double.infinity, 50),
              ),
              onPressed: () {
                onOkPressed();
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
          ],
        );
      },
    );
  }

  void showUpdatePasswordDialog({
    required BuildContext context,
    required String title,
    required Function(String newPass,String oldPass, String rewriteNewPass) onOkPressed,
    required Function() onCancelPressed,
  }) {
    final TextEditingController oldPassTextController = TextEditingController();
    final TextEditingController newPassTextController = TextEditingController();
    final TextEditingController rewriteNewPassTextController = TextEditingController();
    bool isSuccess = false;
    bool isError = false;
    String isErrorMsg = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: isSuccess == true ? Container(
                    height: 270,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "修改密碼成功",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child:
                          Center(
                            child: Image.asset(
                              'assets/images/ok.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Expanded(child: Container()),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text(
                                '確定',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                      isError == true ? Container(
                        width: double.infinity,
                        height: 350,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0), // Set border radius
                          border: Border.all(color: Colors.black), // Add border
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "修改失敗",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                isErrorMsg,
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                setState(() {
                                  isError = false;
                                  isSuccess = false;
                                });
                                //Navigator.of(context).pop();
                              },
                              child: Text(
                                '確定',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(
                        width: double.infinity,
                        height: 400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0), // Set border radius
                          border: Border.all(color: Colors.black), // Add border
                        ),
                        child: Column(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                          fontSize: 30
                                      ),
                                    )
                                )
                            ),
                            TextFormField(
                              controller: oldPassTextController,
                              decoration: const InputDecoration(
                                labelText: '舊密碼',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: newPassTextController,
                              decoration: const InputDecoration(
                                labelText: '新密碼',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: rewriteNewPassTextController,
                              decoration: const InputDecoration(
                                labelText: '再次輸入新密碼',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      onCancelPressed();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      '取消',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      UserData userData = UserDataSingleton.instance;

                                      if (oldPassTextController.text == "") {
                                        setState(() {
                                          isErrorMsg = "未輸入舊密碼";
                                          isError = true;
                                          isSuccess = false;
                                        });
                                      } else if (newPassTextController.text == "") {
                                        setState(() {
                                          isErrorMsg = "未輸入新密碼";
                                          isError = true;
                                          isSuccess = false;
                                        });
                                      } else if (rewriteNewPassTextController.text == "") {
                                        setState(() {
                                          isErrorMsg = "未輸入再次輸入新密碼";
                                          isError = true;
                                          isSuccess = false;
                                        });
                                      } else if (oldPassTextController.text != userData.password) {
                                        setState(() {
                                          isErrorMsg = "舊密碼錯誤";
                                          isError = true;
                                          isSuccess = false;
                                        });
                                      } else if (newPassTextController.text != rewriteNewPassTextController.text){
                                        setState(() {
                                          isErrorMsg = "新密碼與再次輸入新密碼不符";
                                          isError = true;
                                          isSuccess = false;
                                        });
                                      } else {
                                        UpdatePasswordApi().updatePassword(
                                            newPassTextController.text,
                                            (res) {
                                              final jsonData = json.decode(res) as Map<String, dynamic>;
                                              ErrorResponse responseModel = ErrorResponse.fromJson(jsonData['error']);
                                              GlobalDialog.showAlertDialog(
                                                  context,
                                                  "錯誤",
                                                  responseModel.message
                                              );
                                            },
                                            () {
                                              GlobalDialog.showAlertDialog(context, "錯誤", "網路異常");
                                            }
                                        );
                                        userData = userData.updatePassword(newPassTextController.text);
                                        UserDataSingleton.reset();
                                        UserDataSingleton.initialize(userData);
                                        setState(() {
                                          isError = false;
                                          isSuccess = true;
                                        });

                                      }
                                      onOkPressed(
                                        newPassTextController.text,
                                        oldPassTextController.text,
                                        rewriteNewPassTextController.text,
                                      );
                                    },
                                    child: const Text(
                                      '確定',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
              );
            }
        );
      },
    );
  }

  static void showGiveupDialog({
    required BuildContext context,
    required String message,
    required Function() onOkPressed,
    required Function() onCancelPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0), // Set border radius
              border: Border.all(color: Colors.black), // Add border
            ),
            child: Column(
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                            message,
                          style: const TextStyle(
                              fontSize: 20
                          ),
                        )
                    )
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.grey
                        ),
                        onPressed: () {
                          onCancelPressed(); // Call the function when '確定' button is pressed
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            '取消',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Flexible(
                      flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            onOkPressed();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                              '確定',
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class DialogUtils {
  static void showErrorDialog(String title, String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: content,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  static void showErrorCancelDialog(
      BuildContext context,
      String title,
      String content,
      Function() onOkPressed
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          content: content,
          onPressed: () {
            Navigator.of(context).pop();
            onOkPressed();
          },
        );
      },
    );
  }

  static void showErrorCenterDialog(String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomErrorCenterDialog(
          content: content,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  static void showCancelCenterDialog(
      BuildContext context,
      String content,
      Function() onOkPressed
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomErrorCenterDialog(
          content: content,
          onPressed: () {
            Navigator.of(context).pop();
            onOkPressed();
          },
        );
      },
    );
  }

  static void showGrabTicketDialog({
    required String id,
    required String title,
    required String content,
    required int time,
    required BuildContext context,
    required Function(double selectedTime) onOkPressed,
    required Function() onCancelPressed,
  }) {
    double selectedTime = 1;
    bool isSelected = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<double> numbers = [time.toDouble(), (time * 1.5), (time * 2)];
        List<double> numbers2 = [(time * 2.5), (time * 3), (time * 3.5)];

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 380,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: numbers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: GestureDetector(
                              onTap: () {
                                  selectedTime = numbers[index];
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedTime == numbers[index]
                                        ? Colors.black
                                        : Colors.black,
                                    width: 1,
                                  ),
                                  color: selectedTime == numbers[index]
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    numbers[index].toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: numbers2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: GestureDetector(
                              onTap: () {
                                selectedTime = numbers2[index];
                                isSelected = true;
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black,
                                    width: 1,
                                  ),
                                  color: isSelected ? Colors.black : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    numbers2[index].toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          onCancelPressed();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          onOkPressed(selectedTime);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '確定',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void showImageDialog(String title, String image, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomImageDialog(
          title: title,
          imagePath: image,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class CustomImageDialog extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomImageDialog({
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child:
            Center(
              child: Image.asset(
                'assets/images/$imagePath.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          const SizedBox(height: 20),
          //Expanded(child: Container()),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(
                  '確定',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomDialog({
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
          ),
          const SizedBox(height: 20),
          //Expanded(child: Container()),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(
                  '確定',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomErrorCenterDialog extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;

  const CustomErrorCenterDialog({
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
          const SizedBox(height: 20),
          //Expanded(child: Container()),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(
                  '確定',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GrabTicketDialog extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final int time;
  final Function(double selectedTime) onOkPressed;
  final Function() onCancelPressed;

  GrabTicketDialog({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.onOkPressed,
    required this.onCancelPressed,
  });

  @override
  _GrabTicketDialogState createState() => _GrabTicketDialogState();
}

class _GrabTicketDialogState extends State<GrabTicketDialog> {
  double selectedTime = 1;
  int isSelectedIndex = 7;

  @override
  Widget build(BuildContext context) {
    List<double> numbers = [widget.time.toDouble(), (widget.time * 1.5), (widget.time * 2)];
    List<double> numbers2 = [(widget.time * 2.5), (widget.time * 3), (widget.time * 3.5)];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 380,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: numbers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            selectedTime = numbers[index];
                            setState(() {
                              isSelectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelectedIndex == index
                                    ? Colors.black
                                    : Colors.black,
                                width: 1,
                              ),
                              color: isSelectedIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                numbers[index].toString(),
                                style: TextStyle(
                                  color: (isSelectedIndex == index) ? Colors.white : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: numbers2.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            selectedTime = numbers2[index];
                            print("press selectedTime $selectedTime");
                            setState(() {
                              isSelectedIndex = index + 3;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (isSelectedIndex == index + 3) ? Colors.black : Colors.black,
                                width: 1,
                              ),
                              color: (isSelectedIndex == index +3) ? Colors.black : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                numbers2[index].toString(),
                                style: TextStyle(
                                  color: (isSelectedIndex == index +3) ? Colors.white : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      widget.onCancelPressed();
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      widget.onOkPressed(selectedTime);
                    },
                    child: Text(
                      '確定',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
