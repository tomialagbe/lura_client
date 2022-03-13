import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer/auth_service.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

class LuraApp extends StatelessWidget {
  const LuraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationService()),
      ],
      child: Builder(builder: (context) {
        final router = buildRouter(context, kIsWeb);
        return MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          title: 'Lura',
          theme: LuraTheme.defaultTheme,
        );
      }),
    );
  }
}
