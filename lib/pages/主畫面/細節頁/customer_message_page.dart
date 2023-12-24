import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/model/user_data_singleton.dart';




class CustomerMessagePage extends StatefulWidget {
  const CustomerMessagePage({super.key});

  @override
  State<CustomerMessagePage> createState() => _CustomerMessagePageState();
}

class _CustomerMessagePageState extends State<CustomerMessagePage> {


  List<String> sentMsgList = ['哈嘍你好嗎','請聯絡','123','你好我是誰誰誰誰，聯絡電話為....','測試','我現在路上前往中','5566'];
  //late CameraController controller;
  late List<CameraDescription> _cameras;
  String sentedMsg = '';

  @override
  void initState() {
    super.initState();
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


    return Scaffold(
      appBar: AppBar(
        title: Text("訂單"),
      ),
      body: Stack(

      ),
    );
  }

  Future<void> openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
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

// 將 DateTime 格式化為 "星期三 19:13" 格式
    String formattedDate = DateFormat.EEEE().add_jm().format(dateTime);
    return (formattedDate); // 顯示 "星期三 19:13" 格式的日期和時間
  }

  Future<void> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Use the picked image file in your application
      // For example, you can display the selected image in an Image widget
      // You can also perform other operations with the pickedFile
    }
  }
}
