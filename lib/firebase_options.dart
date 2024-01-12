// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtCaqKb7kOT225Nj3VLU_hPCJL_8MsUec',
    appId: '1:770594185182:web:24bc1bf6b2d2691d82874f',
    messagingSenderId: '770594185182',
    projectId: 'taxi-a82f8',
    authDomain: 'taxi-a82f8.firebaseapp.com',
    storageBucket: 'taxi-a82f8.appspot.com',
    measurementId: 'G-VYF1RH0C2C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaXxWYtjpr-dxavnDnOoevrkKotIn2QoY',
    appId: '1:770594185182:android:6e4ffb23cafe6ad982874f',
    messagingSenderId: '770594185182',
    projectId: 'taxi-a82f8',
    storageBucket: 'taxi-a82f8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7HLW7vAqkiBTUU-Cn68z-r6pl_GAt32g',
    appId: '1:770594185182:ios:7e3cdae12817864682874f',
    messagingSenderId: '770594185182',
    projectId: 'taxi-a82f8',
    storageBucket: 'taxi-a82f8.appspot.com',
    androidClientId: '770594185182-0s74bfc4f49imt6n1a483b1956a8315b.apps.googleusercontent.com',
    iosBundleId: 'com.Glad.Car-Driver-test',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7HLW7vAqkiBTUU-Cn68z-r6pl_GAt32g',
    appId: '1:770594185182:ios:fc326173ed01ac0582874f',
    messagingSenderId: '770594185182',
    projectId: 'taxi-a82f8',
    storageBucket: 'taxi-a82f8.appspot.com',
    androidClientId: '770594185182-0s74bfc4f49imt6n1a483b1956a8315b.apps.googleusercontent.com',
    iosBundleId: 'com.example.new_glad_driver.RunnerTests',
  );
}
