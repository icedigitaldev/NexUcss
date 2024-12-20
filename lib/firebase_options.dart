// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCJvyr4uooUYNN6FkV-WhGCNaj4h9BvFE',
    appId: '1:402400598490:android:fb8beac0b48665bf1a88e3',
    messagingSenderId: '402400598490',
    projectId: 'nexucss',
    storageBucket: 'nexucss.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRgEcRVWlUyETH4pZ7ADR1Ay2y-xkuAmQ',
    appId: '1:402400598490:ios:30cd6754506316821a88e3',
    messagingSenderId: '402400598490',
    projectId: 'nexucss',
    storageBucket: 'nexucss.appspot.com',
    iosBundleId: 'com.icedigital.nexucss',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCJYfdU8o3RUzAeyoOv2V9Id6uvUptBNsc',
    appId: '1:402400598490:web:67f27339ad92f5071a88e3',
    messagingSenderId: '402400598490',
    projectId: 'nexucss',
    authDomain: 'nexucss.firebaseapp.com',
    storageBucket: 'nexucss.appspot.com',
    measurementId: 'G-TK07M4PV0X',
  );
}
