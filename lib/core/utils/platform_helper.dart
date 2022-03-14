import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformHelper {
  static bool get isMobile => isIOS || isAndroid;

  static bool get isWeb => kIsWeb;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;
}
