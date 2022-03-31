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
class StagingFirebaseOptions {
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
    apiKey: 'AIzaSyA1oZhthUPmEec6q4h63m1LEo-YHTW1uJ0',
    appId: '1:781371618532:web:52a64ad9a8252d97c728f1',
    messagingSenderId: '781371618532',
    projectId: 'lura-staging',
    authDomain: 'lura-staging.firebaseapp.com',
    storageBucket: 'lura-staging.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA37uuc-NHHDzfCNqThzaud-9Sx8bqyLXw',
    appId: '1:781371618532:android:4044f3d5034974bec728f1',
    messagingSenderId: '781371618532',
    projectId: 'lura-staging',
    storageBucket: 'lura-staging.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgS7jYHT_rFAdow-_dfW2FSWYWlxf1L7o',
    appId: '1:781371618532:ios:da8e67eff60ac2bfc728f1',
    messagingSenderId: '781371618532',
    projectId: 'lura-staging',
    storageBucket: 'lura-staging.appspot.com',
    iosClientId:
        '781371618532-6k6gib0drf5qp9tggmvkr39i3q5vl0mn.apps.googleusercontent.com',
    iosBundleId: 'so.lura',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgS7jYHT_rFAdow-_dfW2FSWYWlxf1L7o',
    appId: '1:781371618532:ios:da8e67eff60ac2bfc728f1',
    messagingSenderId: '781371618532',
    projectId: 'lura-staging',
    storageBucket: 'lura-staging.appspot.com',
    iosClientId:
        '781371618532-6k6gib0drf5qp9tggmvkr39i3q5vl0mn.apps.googleusercontent.com',
    iosBundleId: 'so.lura',
  );
}
