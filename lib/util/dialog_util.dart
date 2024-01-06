import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                    "金額: $price 元",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "里程數: $distance 公里",
                    style: TextStyle(
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
                          '結帳回空車畫面',
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
                minimumSize: Size(double.infinity, 50),
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
                          onCancelPressed();
                          Navigator.of(context).pop();
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
                          onOkPressed(selectedTime);
                          Navigator.of(context).pop();
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
      },
    );
  }


// static void showGrabTicketDialog({
//     required String id,
//     required String title,
//     required String content,
//     required int time,
//     required BuildContext context,
//     required Function(double selectedTime) onOkPressed,
//     required Function() onCancelPressed,
//   }) {
//     double selectedTime = 1;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         List<double> numbers = [time.toDouble(), (time*1.5), (time*2)];
//         List<double> numbers2 = [(time*2.5), (time*3),(time*3.5)];
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             height: 380,
//             width: double.infinity,
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16.0),
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                     child: Center(
//                       child: Text(
//                         content,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                     )
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(height: 20,),
//                     Container(
//                       height: 80, // 給一個固定的高度，可以根據需求調整
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: numbers.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: GestureDetector(
//                               onTap: () {
//                                 selectedTime = numbers2[index];
//                               },
//                               child: Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     numbers[index].toString(),
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     Container(
//                       height: 80, // 給一個固定的高度，可以根據需求調整
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: numbers2.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: GestureDetector(
//                               onTap: () {
//                                 print("grabTicket ${numbers2[index]}");
//                                 selectedTime = numbers2[index];
//                               },
//                               child: Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     numbers2[index].toString(),
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 //Expanded(child: Container()),
//                 Row(
//                   children: [
//                     Flexible(
//                       flex: 1,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             minimumSize: Size(double.infinity, 50),
//                             backgroundColor: Colors.grey
//                         ),
//                         onPressed: () {
//                           onCancelPressed(); // Call the function when '確定' button is pressed
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           '取消',
//                           style: TextStyle(
//                               fontSize: 18
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20,),
//                     Flexible(
//                       flex: 1,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(double.infinity, 50),
//                         ),
//                         onPressed: () {
//                           onOkPressed(selectedTime);
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           '確定',
//                           style: TextStyle(
//                               fontSize: 18
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

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
