import 'package:flutter/material.dart';
import 'package:lura_client/core/utils/platform_helper.dart';

PreferredSizeWidget? luraAppBar(BuildContext context) {
  if (PlatformHelper.isWeb) {
    return null;
  }

  return AppBar(
    title: Image.asset(
      'assets/images/lura_logo_icon_alt.png',
      height: 50,
    ),
    // backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
    automaticallyImplyLeading: true,
  );
}

PreferredSizeWidget luraTransparentAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
