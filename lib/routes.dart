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
              return const CreatePrinterScreen();
            },
          ),
          GoRoute(
            path: 'printer-created',
            name: 'printer-created',
            builder: (ctx, state) {
              return const PrinterCreatedScreen(forCreationComplete: true);
            },
          ),
          GoRoute(
            path: 'activate-printer',
            name: 'activate-printer',
            builder: (ctx, state) {
              return const PrinterCreatedScreen(
                forActivation: true,
                forCreationComplete: false,
              );
            },
          ),
          GoRoute(
            path: 'printer-actions',
            name: 'printer-actions',
            builder: (ctx, state) {
              return const PrinterCreatedScreen(
                forActivation: false,
                forCreationComplete: false,
                showReceiptButton: true,
                hideActivationButton: true,
              );
            },
          ),
          GoRoute(
            path: 'printer-actions-offline',
            name: 'printer-actions-offline',
            builder: (ctx, state) {
              return const PrinterCreatedScreen(
                forActivation: false,
                forCreationComplete: false,
                showReceiptButton: true,
              );
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
        redirect: (state) => state
            .namedLocation('printer-created', params: {'page': 'printers'}),
      ),
      GoRoute(
        name: 'printer-activate',
        path: '/printer-activate',
        redirect: (state) => state
            .namedLocation('activate-printer', params: {'page': 'printers'}),
      ),
      GoRoute(
        name: 'mobile-printer-actions',
        path: '/mobile-printer-actions',
        redirect: (state) => state
            .namedLocation('printer-actions', params: {'page': 'printers'}),
      ),
      GoRoute(
        name: 'mobile-printer-actions-offline',
        path: '/mobile-printer-actions-offline',
        redirect: (state) => state.namedLocation('printer-actions-offline',
            params: {'page': 'printers'}),
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
