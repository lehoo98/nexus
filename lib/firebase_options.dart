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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAxXdRZq17pwVI5DuYUNurUkiBYDGj9YWY',
    appId: '1:296815148905:web:1965bc320b638d43e607f8',
    messagingSenderId: '296815148905',
    projectId: 'handwerkrgb',
    authDomain: 'handwerkrgb.firebaseapp.com',
    storageBucket: 'handwerkrgb.firebasestorage.app',
    measurementId: 'G-WS5DYXS4LB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvlGexG7nSBW3xyzFTsQJUbZ0jo7LwcTY',
    appId: '1:296815148905:android:dd61c70c0ee244c5e607f8',
    messagingSenderId: '296815148905',
    projectId: 'handwerkrgb',
    storageBucket: 'handwerkrgb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWhOr_uVLlj3QJ9_h9WwQThxKu9_iGAQE',
    appId: '1:296815148905:ios:4935959a471cb06ae607f8',
    messagingSenderId: '296815148905',
    projectId: 'handwerkrgb',
    storageBucket: 'handwerkrgb.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWhOr_uVLlj3QJ9_h9WwQThxKu9_iGAQE',
    appId: '1:296815148905:ios:4935959a471cb06ae607f8',
    messagingSenderId: '296815148905',
    projectId: 'handwerkrgb',
    storageBucket: 'handwerkrgb.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxXdRZq17pwVI5DuYUNurUkiBYDGj9YWY',
    appId: '1:296815148905:web:7a96c6034b19b507e607f8',
    messagingSenderId: '296815148905',
    projectId: 'handwerkrgb',
    authDomain: 'handwerkrgb.firebaseapp.com',
    storageBucket: 'handwerkrgb.firebasestorage.app',
    measurementId: 'G-86L8NFMEJB',
  );
}
