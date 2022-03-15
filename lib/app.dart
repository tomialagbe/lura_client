import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer/core/viewmodels/receipts_viewmodel.dart';
import 'package:mobile_printer/login_state.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:provider/provider.dart';

import 'core/viewmodels/printers_viewmodel.dart';
import 'routes.dart';

class LuraApp extends StatelessWidget {
  final LoginState loginState;

  const LuraApp({Key? key, required this.loginState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          create: (_) => loginState,
          lazy: false,
        ),
        ChangeNotifierProvider<PrintersViewmodel>(
          create: (ctx) => PrintersViewmodel(),
        ),
        ChangeNotifierProvider<ReceiptsViewmodel>(
          create: (ctx) => ReceiptsViewmodel(),
        ),
        Provider<LuraRouter>(
          create: (ctx) => LuraRouter(loginState: loginState),
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        final router = Provider.of<LuraRouter>(context, listen: false).router;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          title: 'Lura',
          theme: LuraTheme.defaultTheme,
        );
      }),
    );
  }
}
