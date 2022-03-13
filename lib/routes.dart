import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/admin/signin_screen.dart';
import 'package:mobile_printer/admin/signup_screen.dart';
import 'package:mobile_printer/auth_service.dart';
import 'package:provider/provider.dart';

import 'admin/main_screen.dart';

GoRouter? router;

GoRouter buildRouter(BuildContext context, bool isWeb) {
  final authService = context.read<AuthenticationService>();

  router = router ??
      GoRouter(
        initialLocation: '/signin',
        routes: [
          GoRoute(
              path: '/',
              builder: (ctx, state) {
                return MainScreen();
              }),
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
          // final loggedIn = authService.isLoggedIn;
          // final loggingIn = state.subloc == '/signin';
          //
          // if (!loggedIn) {
          //   return '/signin';
          // }
          //
          // if (loggedIn && loggingIn) {
          //   return '/';
          // }

          return null;
        },
        refreshListenable: authService,
      );
  return router!;
}
