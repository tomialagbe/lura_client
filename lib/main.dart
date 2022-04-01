import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lura_client/lura_config.dart';

import 'app.dart';
import 'locator.dart';

Future<void> main({LuraConfig? config}) async {
  assert(config != null);
  runZonedGuarded<Future<void>>(
    () async {
      // has to be inside runZonedGuarded for error handling to work
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: config!.firebaseOptions);

      _registerLicenses();

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

      await setupLocator(config: config);
      runApp(const LuraApp());
    },
    (err, stackTrace) async {
      debugPrintStack(stackTrace: stackTrace);
      debugPrint(err.toString());
    },
  );
}

void _registerLicenses() {}
