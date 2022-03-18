import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lura_client/login_state.dart';
import 'package:lura_client/lura_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    (err, stackTrace) async {},
  );
}

void _registerLicenses() {}
