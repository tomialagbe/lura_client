import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/admin/printers/printer_created_screen.dart';
import 'package:mobile_printer/admin/signin_screen.dart';
import 'package:mobile_printer/admin/signup_screen.dart';
import 'package:provider/provider.dart';

import 'admin/printers/create_printer_screen.dart';
import 'admin/main_screen.dart';
import 'login_state.dart';

class LuraRouter {
  final LoginState loginState;

  LuraRouter({required this.loginState});

  late final GoRouter router = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    refreshListenable: loginState,
    // initialLocation: '/signin',
    routes: [
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
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (ctx, state) {
          return Container();
        },
      ),
      GoRoute(
        path: '/',
        name: 'root',
        redirect: (state) =>
            state.namedLocation('home', params: {'page': 'printers'}),
      ),
      GoRoute(
        name: 'home',
        path: '/home/:page(printers|receipts|feedback)',
        pageBuilder: (ctx, state) {
          final page = state.params['page'] ?? 'printers';
          return MaterialPage(
            key: state.pageKey,
            child: MainScreen(page: page),
          );
        },
        routes: [
          GoRoute(
            path: 'create-printer',
            name: 'create-printer',
            builder: (ctx, state) {
              return CreatePrinterScreen();
            },
          ),
          GoRoute(
            path: 'printer-created',
            name: 'printer-created',
            builder: (ctx, state) {
              return PrinterCreatedScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/printers',
        redirect: (state) =>
            state.namedLocation('home', params: {'page': 'printers'}),
      ),
      GoRoute(
        path: '/receipts',
        redirect: (state) =>
            state.namedLocation('home', params: {'page': 'receipts'}),
      ),
      GoRoute(
        path: '/feedback',
        redirect: (state) =>
            state.namedLocation('home', params: {'page': 'feedback'}),
      ),
      GoRoute(
        name: 'new-printer',
        path: '/new-printer',
        redirect: (state) =>
            state.namedLocation('create-printer', params: {'page': 'printers'}),
      ),
      GoRoute(
        name: 'new-printer-created',
        path: '/new-printer-created',
        redirect: (state) =>
            state.namedLocation('printer-created', params: {'page': 'printers'}),
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Container(
          child: Text('TODO: Error page'),
        ),
      );
    },
    redirect: (state) {
      final loginLoc = state.namedLocation('signin');
      final loggingIn = state.subloc == loginLoc;

      final createAcctLoc = state.namedLocation('signup');
      final creatingAcct = state.subloc == createAcctLoc;

      final loggedIn = loginState.loggedIn;
      final rootLoc = state.namedLocation('root');

      if (!loggedIn && !loggingIn && !creatingAcct) return loginLoc;
      if (loggedIn && (loggingIn || creatingAcct)) return rootLoc;
      return null;
    },
  );
}
