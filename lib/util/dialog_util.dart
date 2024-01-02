import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/respository/%E4%B8%BB%E7%95%AB%E9%9D%A2/grab_ticket_api.dart';

class GlobalDialog {
  static void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: Container(
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
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                onOkPressed(); // Call the function when '確定' button is pressed
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
          ],
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
            padding: EdgeInsets.all(16),
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
                          style: TextStyle(
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
                        child: Text(
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
                          child: Text(
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

class DateUtil {
  String getDate(String dateString)
  {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('M-d HH:mm(E)', 'zh').format(dateTime.toLocal());
    formattedDate = formattedDate.replaceAll("周", "週");
    return formattedDate;
  }

  String getDateYear(String dateString)
  {
    DateTime dateTime = DateTime.parse(dateString);

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    print(formattedDate); // Output: 12-11 13:33 (Mon)
    return formattedDate;
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

    static void showGrabTicketDialog(String id, String title, String content, BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GrabTicketDialog(
            id: id,
            title: title,
            content: content,
            onPressed: () {
              Navigator.of(context).pop();
            },
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
    return  Container(
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

class GrabTicketDialog extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final VoidCallback onPressed;

  const GrabTicketDialog({
    required this.id,
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
    List<int> numbers = [6, 9, 12];
    List<int> numbers2 = [14, 16, 20];
    return Container(
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
          Column(
            children: [
              SizedBox(height: 20,),
              Container(
                height: 80, // 給一個固定的高度，可以根據需求調整
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: numbers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          print("grabTicket ${numbers[index].toString()}");
                          GrabTicketApi.grabTicket(orderId: id, time: numbers2[index], status: 0);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              numbers[index].toString(),
                              style: TextStyle(
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
                height: 80, // 給一個固定的高度，可以根據需求調整
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: numbers2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          print("grabTicket ${numbers2[index]}");
                          GrabTicketApi.grabTicket(orderId: id, time: numbers2[index], status: 0);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              numbers2[index].toString(),
                              style: TextStyle(
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
                  '關閉',
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
