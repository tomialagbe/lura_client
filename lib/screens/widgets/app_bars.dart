import 'package:flutter/material.dart';
import 'package:lura_client/core/utils/platform_helper.dart';

PreferredSizeWidget? luraAppBar(BuildContext context,
    {String? title, List<Widget>? actions}) {
  if (PlatformHelper.isWeb) {
    return null;
  }

  return AppBar(
    elevation: 0,
    title: title != null
        ? Text(title, style: Theme.of(context).textTheme.headline5)
        : null,
    automaticallyImplyLeading: true,
    actions: actions,
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
