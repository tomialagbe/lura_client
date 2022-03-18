import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;

  bool _loggedIn = false;

  LoginState({required this.prefs}) {
    _loggedIn = prefs.getBool(loggedInPrefKey) ?? false;
  }

  bool get loggedIn => _loggedIn;

  set loggedIn(bool value) {
    _loggedIn = value;
    // prefs.setBool(loggedInPrefKey, value);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool(loggedInPrefKey) ?? false;
  }
}
