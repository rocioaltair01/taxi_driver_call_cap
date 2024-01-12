import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_glad_driver/model/user_data_singleton.dart';

import '../components/message_view.dart';

class MessagePageView extends StatefulWidget {
  const MessagePageView({super.key});

  @override
  State<MessagePageView> createState() => _MessagePageViewState();
}

class _MessagePageViewState extends State<MessagePageView> {
  late ScrollController _scrollController;
  final MessageView messageView = MessageView();
  List<String> sentMsgList = ['哈嘍你好嗎','請聯絡','123','你好我是誰誰誰誰，聯絡電話為....','測試','我現在路上前往中','5566'];
  //late CameraController controller;
  // late List<CameraDescription> _cameras;
  String sentedMsg = '';
  bool isLoadingTop = false;
  bool isLoading = false;
  TextEditingController _messageEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
    // controller = CameraController(_cameras[0], ResolutionPreset.max);
    //  controller.initialize().then((_) {
    //    if (!mounted) {
    //      return;
    //    }
    //    setState(() {});
    //  }).catchError((Object e) {
    //    if (e is CameraException) {
    //      switch (e.code) {
    //        case 'CameraAccessDenied':
    //        // Handle access errors here.
    //          break;
    //        default:
    //        // Handle other errors here.
    //          break;
    //      }
    //    }
    //  });
  }


  @override
  Widget build(BuildContext context) {
    messageView.startReadingTwoSideMessage('HHH-8299');

    // if (!isLoading)
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    return isLoading ?
    const Center(
      child: SpinKitFadingCircle(
        color: Colors.black,
        size: 80.0,
      ),
    ) : Scaffold(
      body: Column(
        children: [
          Expanded(child:
          NotificationListener<ScrollNotification>(onNotification: (scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels == 0.0) {
              print('Scrolled to the top');
              isLoadingTop = true;
              setState(() {
                messageView.loadOldMessage();
              });
            }
            return true;
          },
            child:
            StreamBuilder<List<MessageModel>>(
                stream: messageView.messagesController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitFadingCircle(
                      color: Colors.black,
                      size: 80.0,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No messages available.');
                  } else {
                    final messages = snapshot.data!;
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      if (!isLoadingTop)
                        scrollToBottom();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return message.userName == UserDataSingleton.instance.name ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(

                                child: Center(
                                  child: Text(getData(message.date!)),
                                  //height: 16,
                                )),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  margin: EdgeInsets.fromLTRB(16, 6, 16, 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18), // Adjust the radius value as needed
                                      border: (!message.message.contains('https://storage')) ? Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ) : Border.all(
                                        color: Colors.transparent,
                                        width: 0,
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                        child: (!message.message.contains('https://storage')) ?
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 300, // Adjust the maximum width as needed
                                          ),
                                          child: Text(
                                            message.message,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              // Add more styling options as needed
                                            ),
                                          ),
                                        ) :
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 300, // Adjust the maximum width as needed
                                          ),
                                          child: Image.network(
                                            fit: BoxFit.contain,
                                            message.message,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return const Text('Image could not be loaded');
                                            },
                                          ),
                                          width: 200,
                                        ),
                                      )
                                      //Text(message.userName),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 36, 0),
                                  child: Text(
                                    "已傳送",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ) :
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(getData(message.date!)),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      message.userName.substring(message.userName.length - 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18), // Adjust the radius value as needed
                                      border: (!message.message.contains('https://storage')) ? Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ) : Border.all(
                                        color: Colors.transparent,
                                        width: 0,
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(8),
                                          child: (!message.message.contains('https://storage')) ?
                                          Text(message.message) :
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 260, // Adjust the maximum width as needed
                                            ),
                                            child: Image.network(
                                              fit: BoxFit.contain,
                                              message.message,
                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return const Center(
                                                      child: SpinKitFadingCircle(
                                                        color: Colors.black,
                                                        size: 80.0,
                                                      )
                                                  );
                                                }
                                              },
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return const Text('Image could not be loaded');
                                              },
                                            ),
                                          )

                                      )
                                      //Text(message.userName),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                        //   ListTile(
                        //   title: Text(message.message),
                        //   subtitle: Text(message.userName),
                        //   // Add other widgets as per your design
                        // );
                      },
                    );
                  }
                }
            ),
          )
          ),
          Container(
            height: 110,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sentMsgList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () async{
                            await messageView.sendMessage(sentMsgList[index], (bool success) {
                              setState(() {
                                isLoading = false;
                                isLoadingTop = false;
                              });
                            });
                          },
                          child: Container(
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                      sentMsgList[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          )
                      );
                    },
                  ),
                ),
                Container(
                  height: 5,
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () async{
                            setState(() {
                              //showCamera = true;
                            });
                            // controller.takePicture().then((XFile? file) {
                            //   if(mounted) {
                            //     if(file != null) {
                            //       print("Picture saved to ${file.path}");
                            //     }
                            //   }
                            // });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/camera.png',
                              width: 36,
                              height: 36,
                            ),
                          )
                      ),
                      InkWell(
                          onTap: () {
                            openGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            child: Image.asset(
                              'assets/images/photo.png',
                              width: 36,
                              height: 36,
                            ),
                          )
                      ),
                      Expanded(
                          child: TextField(
                            controller: _messageEditingController,
                            decoration: const InputDecoration(
                              labelText: '輸入文字', // Placeholder text
                              border: InputBorder.none,
                              //border: OutlineInputBorder(), // Border decoration
                            ),
                          )
                      ),
                      InkWell(
                          onTap: () async{
                            await messageView.sendMessage(_messageEditingController.text, (bool success) {
                              setState(() {
                                isLoadingTop = false;
                                isLoading = false;
                              });
                            });
                            _messageEditingController.text = '';
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/sent.png',
                              width: 36,
                              height: 26,
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> openCamera() async {
    // final cameras = await availableCameras();
    // final firstCamera = cameras.first;
    // Navigate to a new screen where you can take a picture using the camera package
    // You might use Navigator.push to navigate to the camera screen
    // Pass the CameraDescription to the camera screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CameraPreview(controller),
    //   ),
    // );
  }

  String getData(DateTime dateTime) {
    DateTime parsedOrderTime = dateTime.add(Duration(hours: 8));
    String formattedDateOrderTime = DateFormat('M-d HH:mm(E)', 'zh').format(parsedOrderTime!);
// 將 DateTime 格式化為 "星期三 19:13" 格式
    String formattedDate = DateFormat.EEEE().add_jm().format(dateTime);
    return (formattedDateOrderTime); // 顯示 "星期三 19:13" 格式的日期和時間
  }

  Future<void> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Use the picked image file in your application
      // For example, you can display the selected image in an Image widget
      // You can also perform other operations with the pickedFile
    }
  }

  void scrollToBottom() {
    //_listKey.currentState?.insertItem(messages.length - 1);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
