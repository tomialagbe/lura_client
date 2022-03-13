import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer/login_state.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

class LuraApp extends StatelessWidget {
  final LoginState loginState;

  const LuraApp({Key? key, required this.loginState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(create: (_) => loginState, lazy: false),
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
