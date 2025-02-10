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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAuaRlZ2nR2q1qFom3QHCwIJTJG4247mHw',
    appId: '1:785644481863:web:b86c93ab4caacccb113062',
    messagingSenderId: '785644481863',
    projectId: 'shatter-66908',
    authDomain: 'shatter-66908.firebaseapp.com',
    storageBucket: 'shatter-66908.firebasestorage.app',
    measurementId: 'G-1S0F93WT9T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnkCQNvgQvcfTuED2Gagk3ZFiTiT5WTpg',
    appId: '1:785644481863:android:624ffa67f8363de8113062',
    messagingSenderId: '785644481863',
    projectId: 'shatter-66908',
    storageBucket: 'shatter-66908.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNmKnp70Dy4PKmc1qKrRTMTaZEkEuUJ3k',
    appId: '1:785644481863:ios:ebf67798c5e39b3d113062',
    messagingSenderId: '785644481863',
    projectId: 'shatter-66908',
    storageBucket: 'shatter-66908.firebasestorage.app',
    iosClientId: '785644481863-ajbi8jvkosu8tsr848d08clkg8pf9m3t.apps.googleusercontent.com',
    iosBundleId: 'com.example.shatterVcs',
  );

}