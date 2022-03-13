import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

class LuraApp extends StatelessWidget {
  const LuraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(context, kIsWeb);
    return MultiProvider(
      providers: [

      ],
      child: MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
