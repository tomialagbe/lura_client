import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/authentication/bloc/authentication_bloc.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';
import 'package:lura_client/screens/printers/bloc/printers_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';
import 'package:lura_client/ui/theme.dart';

import 'core/utils/platform_helper.dart';
import 'routes.dart';

class LuraApp extends StatefulWidget {
  const LuraApp({Key? key}) : super(key: key);

  @override
  State<LuraApp> createState() => _LuraAppState();
}

class _LuraAppState extends State<LuraApp> {
  final authBloc = AuthenticationBloc();
  final businessBloc = BusinessBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => authBloc,
          lazy: false,
        ),
        BlocProvider(create: (_) => businessBloc, lazy: false),
        BlocProvider(
          create: (_) => PrintersScreenBloc(businessBloc: businessBloc),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => SelectedPrinterBloc(),
          lazy: false,
        ),
        if (!PlatformHelper.isWeb)
          BlocProvider(
            create: (ctx) => PrinterEmulationBloc(
                selectedPrinterBloc: ctx.read<SelectedPrinterBloc>()),
            lazy: false,
          ),
        BlocProvider(
          create: (_) => LuraRouter(
            authenticationBloc: authBloc,
            businessBloc: businessBloc,
          ),
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        final router = context.read<LuraRouter>().router;

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
