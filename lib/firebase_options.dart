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
    apiKey: 'AIzaSyAWARiJVqvkwL1Pas1XaawutEgzg3--TRE',
    appId: '1:7092414875:web:89726898513ad4447c593e',
    messagingSenderId: '7092414875',
    projectId: 'idyllic-theater-445419-c9',
    authDomain: 'idyllic-theater-445419-c9.firebaseapp.com',
    storageBucket: 'idyllic-theater-445419-c9.firebasestorage.app',
    measurementId: 'G-VLP2LDT1Y4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvEW31XXc05vj5gLLcuaIyllJ9inbvs3g',
    appId: '1:7092414875:android:b0b13c72043cfae07c593e',
    messagingSenderId: '7092414875',
    projectId: 'idyllic-theater-445419-c9',
    storageBucket: 'idyllic-theater-445419-c9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcLfXM8QAsqwylAW_mwweea5yvJyzHkFE',
    appId: '1:7092414875:ios:4200ef8fd3919d657c593e',
    messagingSenderId: '7092414875',
    projectId: 'idyllic-theater-445419-c9',
    storageBucket: 'idyllic-theater-445419-c9.firebasestorage.app',
    iosBundleId: 'com.example.medSupportGaza',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcLfXM8QAsqwylAW_mwweea5yvJyzHkFE',
    appId: '1:7092414875:ios:4200ef8fd3919d657c593e',
    messagingSenderId: '7092414875',
    projectId: 'idyllic-theater-445419-c9',
    storageBucket: 'idyllic-theater-445419-c9.firebasestorage.app',
    iosBundleId: 'com.example.medSupportGaza',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAWARiJVqvkwL1Pas1XaawutEgzg3--TRE',
    appId: '1:7092414875:web:d76be331821d1e197c593e',
    messagingSenderId: '7092414875',
    projectId: 'idyllic-theater-445419-c9',
    authDomain: 'idyllic-theater-445419-c9.firebaseapp.com',
    storageBucket: 'idyllic-theater-445419-c9.firebasestorage.app',
    measurementId: 'G-WEM6WY05JQ',
  );
}
