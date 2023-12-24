import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../constants/constants.dart';

class MessageView {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<MessageModel>> messagesStream;
  late StreamController<List<MessageModel>> messagesController;
  int messageCount = 25;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<MessageModel> messagesList = [];

  MessageView() {
    messagesController = StreamController<List<MessageModel>>.broadcast();
  }

  // Future<String> uploadMessageImage(String fileName, List<int> file, String token) async {
  //   final String imagePath = "messages/$fileName"; // Set your desired path in the storage bucket
  //
  //   try {
  //     final UploadTask task = _storage.ref().child(imagePath).putData(Uint8List.fromList(file));
  //
  //     final TaskSnapshot snapshot = await task;
  //
  //     if (snapshot.state == TaskState.success) {
  //       final String imageUrl = await snapshot.ref.getDownloadURL();
  //       return imageUrl;
  //     } else {
  //       print("Failed to upload image");
  //       return "Failed to upload image";
  //     }
  //   } catch (error) {
  //     print("Error during image upload $error");
  //     return "Error during image upload";
  //   }
  // }

  void startReadingTwoSideMessage(String driverId) {
    _db
        .collection('users')
        .doc('message')
        .collection('889')
        .orderBy('date')
        .limitToLast(25)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return MessageModel(
        date: (data['date'] as Timestamp).toDate(),
        message: data['message'] ?? '',
        user: data['user'] ?? '',
        userName: data['userName'] ?? '',
      );
    }).toList())
        .listen((List<MessageModel> messages) {
      messagesList = messages;
      messagesController.add(messages);
    });
  }

  void loadOldMessage() async {
    messageCount += 10;
    _db
        .collection('users')
        .doc('message')
        .collection('889')
        .orderBy('date')
        .limitToLast(messageCount)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print("data $data");
      return MessageModel(
        date: (data['date'] as Timestamp).toDate(),
        message: data['message'] ?? '',
        user: data['user'] ?? '',
        userName: data['userName'] ?? '',
      );

    }).toList())
        .listen((List<MessageModel> messages) {
      messagesList = messages;
      messagesController.add(messages);
    });
  }

  Future<void> sendMessage(String message, Function(bool) onSendMessageComplete) async {
    try {
      Map<String, dynamic> messageMap = {
        'message': message,
        'user': 'HHH-8299',
        'userName': '林聰明',
        'date': FieldValue.serverTimestamp(),
      };
      await sendMessageToFirestore(messageMap);
      onSendMessageComplete(true);
    } catch (e) {
      onSendMessageComplete(false);
    }
  }

  Future<void> sendMessageToFirestore(Map<String, dynamic> messageMap) async {
    await _db.collection('users').doc('message').collection('889').add(messageMap);
  }

  Future<Uint8List> getImageBytesFromAsset(String assetName) async {
    final ByteData data = await rootBundle.load('assets/images/$assetName');
    return data.buffer.asUint8List();
  }

  // Future<bool> isUserSignedIn() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //   print("user $user");
  //   return user != null;
  // }

  Future<void> uploadImageToFirebaseStorage() async {
    final Uint8List imageUint8List = await getImageBytesFromAsset('sssss.jpeg');
   // await isUserSignedIn();

    // final metadata = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();

    try {
      await storageRef.child('test/99041707791.jpeg').putData(imageUint8List);
      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  uploadImage(Uint8List imageUint8List) async {
    final metadata = SettableMetadata(contentType: "image/jpeg");

    final storageRef = FirebaseStorage.instance.ref();
    print("storageRef ${storageRef.bucket}");

    print("imageUint8List $imageUint8List");
    try {
      await storageRef
          .child("test/-9904170779.jpg")
          .putData(imageUint8List);
    } catch(e)
    {
      print("eee $e");
    }

//     await uploadTask.onError((error, stackTrace) {print(error)});
// // Listen for state changes, errors, and completion of the upload.
//
//     try {
//       uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
//         switch (taskSnapshot.state) {
//           case TaskState.running:
//             final progress =
//                 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
//             print("Upload is $progress% complete.");
//             break;
//           case TaskState.paused:
//             print("Upload is paused.");
//             break;
//           case TaskState.canceled:
//             print("Upload was canceled");
//             break;
//           case TaskState.error:
//             print("Upload was error ");
//             // Handle unsuccessful uploads
//             break;
//           case TaskState.success:
//             print("Upload was success");
//             // Handle successful uploads on complete
//             // ...
//             break;
//         }
//       }, onError: (e) {
//         // Handle any errors that occur in the stream
//         print("Error in stream: $e");
//       });
//     }catch(e)
//     {
//       print("e $e");
//     }

  }

  Future<void> uploadMessageImage(
      String fileName, File file, String token) async {
    print("object");
    final Reference storageReference =
    _storage.ref().child('message/$fileName');
    print("object1 $file");
    try {
      await storageReference.putFile(file);
      String downloadURL = await storageReference.getDownloadURL();
      sendMessage(downloadURL, (success) {
        print("success $success");
      });
      print('Handle the download URL as needed: $downloadURL');
    } catch (e) {
      // Handle errors if the upload fails
      print('Error uploading image: $e');
    }
    print("object2");
  }
}

class MessageModel {
  final DateTime? date;
  final String message;
  final String user;
  final String userName;

  MessageModel({
    this.date,
    required this.message,
    required this.user,
    required this.userName,
  });
}


class UploadMessageImageApiRequest {
  Future<void> uploadMessageImage(
      String fileName, File file, String token) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageReference =
    storage.ref().child('message/$fileName');
    try {
      await storageReference.putFile(file);
      String downloadURL = await storageReference.getDownloadURL();
      // Handle the download URL as needed
      //String message, Function(bool) onSendMessageComplete
      // sendMessage(downloadURL, (success) {
      // });
      print('Handle the download URL as needed: $downloadURL');
    } catch (e) {
      // Handle errors if the upload fails
      print('Error uploading image: $e');
    }
  }
// Future<void> uploadMessageImage(String fileName, Uint8List file, String token) async {
//   final url = '$baseUrl/uploadMessageImageEndpoint';
//
//   final request = http.MultipartRequest('POST', Uri.parse(url));
//   request.headers['Authorization'] = 'Bearer $token';
//
//   final multipartFile = http.MultipartFile.fromBytes('image', file, filename: fileName);
//   request.files.add(multipartFile);
//
//   try {
//     final response = await request.send();
//     final String responseString = await response.stream.bytesToString();
//     print("response: ${response.statusCode}");
//     if (response.statusCode >= 500) {
//       // Handle server error
//       // You may need to parse the responseString to get more details
//     } else if (response.statusCode >= 400) {
//       // Handle client error
//       // You may need to parse the responseString to get more details
//     } else {
//       // Handle successful response
//       // You may need to parse the responseString to get more details
//     }
//   } catch (error) {
//     // Handle network error
//   }
// }
}

class MessageConverter {
  List<MessageViewModel> convertMessage(List<DocumentSnapshot> messageList) {
    List<MessageViewModel> messages = [];

    messageList.forEach((snapShot) {
      Map<String, dynamic>? data = snapShot.data() as Map<String, dynamic>?;

      if (data != null) {
        String message = data['message'].toString();
        String user = data['user'].toString();
        String userName = data['userName'].toString();

        if (data['date'] != null) {
          Timestamp timeStamp = data['date'] as Timestamp;
          DateTime date = timeStamp.toDate();
          messages.add(MessageViewModel(date, message, user, userName));
        } else {
          messages.add(MessageViewModel(null, message, user, userName));
        }
      }
    });

    return messages;
  }
}

class MessageViewModel {
  final DateTime? date;
  final String message;
  final String user;
  final String userName;

  MessageViewModel(this.date, this.message, this.user, this.userName);
}