import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_printer/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'locator.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      // has to be inside runZonedGuarded for error handling to work
      WidgetsFlutterBinding
          .ensureInitialized();
      _registerLicenses();

      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

      final loginState = LoginState(prefs: await SharedPreferences.getInstance());
      loginState.checkLoggedIn();
      await setupLocator();
      runApp(LuraApp(loginState: loginState));
    },
    (err, stackTrace) async {},
  );
}

void _registerLicenses() {}
