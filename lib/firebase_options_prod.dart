// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
class ProdFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAptjOkDhhYHH2JP3xlLJvp-qHB_IUxe44',
    appId: '1:376445519523:web:3461784ff504d3e6a2a116',
    messagingSenderId: '376445519523',
    projectId: 'lura-33bc9',
    authDomain: 'lura-33bc9.firebaseapp.com',
    storageBucket: 'lura-33bc9.appspot.com',
    measurementId: 'G-3Z3JLHNMQ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlDoFSleXQAXm5o8iajYVCFnK7O_Ni_Bc',
    appId: '1:376445519523:android:139ef839e47d6e4da2a116',
    messagingSenderId: '376445519523',
    projectId: 'lura-33bc9',
    storageBucket: 'lura-33bc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7IEJE0AVRq5UTIsI61NTD5MfJVFVDv-M',
    appId: '1:376445519523:ios:a8a5e93320516705a2a116',
    messagingSenderId: '376445519523',
    projectId: 'lura-33bc9',
    storageBucket: 'lura-33bc9.appspot.com',
    iosClientId:
        '376445519523-3415gpg8prjmihqe0iqvi11lfakv0qi3.apps.googleusercontent.com',
    iosBundleId: 'so.lura',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7IEJE0AVRq5UTIsI61NTD5MfJVFVDv-M',
    appId: '1:376445519523:ios:a8a5e93320516705a2a116',
    messagingSenderId: '376445519523',
    projectId: 'lura-33bc9',
    storageBucket: 'lura-33bc9.appspot.com',
    iosClientId:
        '376445519523-3415gpg8prjmihqe0iqvi11lfakv0qi3.apps.googleusercontent.com',
    iosBundleId: 'so.lura',
  );
}
