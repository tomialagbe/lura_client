import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/admin/signin_screen.dart';
import 'package:mobile_printer/admin/signup_screen.dart';
import 'package:provider/provider.dart';

import 'admin/printers/create_printer_screen.dart';
import 'admin/main_screen.dart';
import 'login_state.dart';

GoRouter? router;

GoRouter buildRouter(BuildContext context, bool isWeb) {
  final loginState = context.read<LoginState>();

  router = router ??
      GoRouter(
        // debugLogDiagnostics: kDebugMode,
        urlPathStrategy: UrlPathStrategy.path,
        refreshListenable: loginState,
        initialLocation: '/signin',
        routes: [
          GoRoute(
              path: '/',
              name: 'root',
              builder: (ctx, state) {
                return MainScreen();
              }),
          GoRoute(
            path: '/create_printer',
            name: 'create_printer',
            builder: (ctx, state) {
              return CreatePrinterScreen();
            },
          ),
          GoRoute(
            path: '/signup',
            name: 'signup',
            builder: (ctx, state) {
              return SignupScreen();
            },
          ),
          GoRoute(
            path: '/signin',
            name: 'signin',
            builder: (ctx, state) {
              return SigninScreen();
            },
          ),
          GoRoute(
            path: '/forgot_password',
            name: 'forgot_password',
            builder: (ctx, state) {
              return Container();
            },
          )
        ],
        redirect: (state) {
          // final loginLoc = state.namedLocation('signin');
          // final loggingIn = state.subloc == loginLoc;
          //
          // final createAcctLoc = state.namedLocation('signup');
          // final creatingAcct = state.subloc == createAcctLoc;
          //
          // final loggedIn = loginState.loggedIn;
          // final rootLoc = state.namedLocation('root');
          //
          // if (!loggedIn && !loggingIn && !creatingAcct) return loginLoc;
          // if (loggedIn && (loggingIn || creatingAcct)) return rootLoc;
          return null;
        },
      );
  return router!;
}
