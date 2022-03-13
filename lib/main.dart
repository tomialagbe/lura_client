import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      // has to be inside runZonedGuarded for error handling to work
      WidgetsFlutterBinding
          .ensureInitialized();
      _registerLicenses();

      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

      runApp(LuraApp());
    },
    (err, stackTrace) async {},
  );
}

void _registerLicenses() {}
