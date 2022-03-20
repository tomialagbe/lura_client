import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/core/authentication/bloc/authentication_bloc.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:lura_client/core/business/model.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';
import 'package:lura_client/core/utils/platform_helper.dart';
import 'package:lura_client/screens/authentication/bloc/login_screen_bloc.dart';
import 'package:lura_client/screens/authentication/bloc/onboarding_screen_bloc.dart';
import 'package:lura_client/screens/authentication/bloc/signup_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/create_printer_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/printer_activation_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/printers_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'screens/authentication/onboarding_screen.dart';
import 'screens/authentication/signin_screen.dart';
import 'screens/main_screen.dart';
import 'screens/printers/create_printer_screen.dart';
import 'screens/printers/printer_activation_screen.dart';
import 'screens/printers/printer_created_screen.dart';
import 'screens/printers/printer_standby_screen.dart';
import 'screens/authentication/signup_screen.dart';

class LuraRouter extends Cubit<String> {
  final AuthenticationBloc authenticationBloc;
  final BusinessBloc businessBloc;

  LuraRouter({
    required this.authenticationBloc,
    required this.businessBloc,
  }) : super('');

  late final GoRouter router = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    refreshListenable: GoRouterRefreshStream(
      Rx.combineLatest2<AuthenticationState, Business?,
          Tuple2<AuthenticationState, Business?>>(
        authenticationBloc.stream,
        businessBloc.stream,
        (a, b) => Tuple2(a, b),
      ),
    ),
    routes: [
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (ctx, state) {
          return BlocProvider(
            create: (_) => SignupScreenBloc(),
            child: const SignupScreen(),
          );
        },
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (ctx, state) {
          return BlocProvider(
            create: (_) => LoginScreenBloc(),
            child: const SigninScreen(),
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (ctx, state) {
          return BlocProvider(
            create: (context) => OnboardingScreenBloc(
                businessBloc: context.read<BusinessBloc>()),
            child: const OnboardingScreen(),
          );
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
              return BlocProvider(
                create: (context) => CreatePrinterScreenBloc(
                  printersScreenBloc: context.read<PrintersScreenBloc>(),
                  selectedPrinterBloc: context.read<SelectedPrinterBloc>(),
                ),
                child: const CreatePrinterScreen(),
              );
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
          if (!PlatformHelper.isWeb) ...[
            GoRoute(
              name: 'printer-activation-screen',
              path: 'printer-activation-screen',
              builder: (ctx, state) {
                return BlocProvider(
                  create: (ctx) => PrinterActivationScreenBloc(
                      selectedPrinterBloc: ctx.read<SelectedPrinterBloc>(),
                      printerEmulationBloc: ctx.read<PrinterEmulationBloc>()),
                  child: const PrinterActivationScreen(),
                );
              },
            ),
            GoRoute(
              name: 'printer-standby-screen',
              path: 'printer-standby-screen',
              builder: (ctx, state) {
                return PrinterStandbyScreen();
              },
            ),
          ],
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
      if (!PlatformHelper.isWeb) ...[
        GoRoute(
          name: 'printer-activation',
          path: '/printer-activation',
          redirect: (state) => state.namedLocation('printer-activation-screen',
              params: {'page': 'printers'}),
        ),
        GoRoute(
          name: 'printer-standby',
          path: '/printer-standby',
          redirect: (state) => state.namedLocation('printer-standby-screen',
              params: {'page': 'printers'}),
        ),
      ],
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

      final loggedIn = authenticationBloc.state !=
          const AuthenticationState.unauthenticated();

      final rootLoc = state.namedLocation('root');
      final onboardingLoc = state.namedLocation('onboarding');
      final onboarding = state.subloc == onboardingLoc;

      final onboarded = businessBloc.state != null &&
          businessBloc.state != BusinessBloc.noBusiness;

      if (!loggedIn && !loggingIn && !creatingAcct) return loginLoc;
      if (loggedIn && !onboarded && !onboarding) {
        return onboardingLoc;
      }

      if (loggedIn && onboarded && (loggingIn || creatingAcct || onboarding)) {
        return rootLoc;
      }
      return null;
    },
  );
}
