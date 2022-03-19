import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:lura_client/core/printers/printers_repository.dart';
import 'package:lura_client/core/repository/print_station_repository.dart';
import 'package:lura_client/lura_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'core/authentication/authentication_repository.dart';
import 'core/business/business_repository.dart';
import 'login_state.dart';

final locator = GetIt.instance;

Future setupLocator({required LuraConfig config}) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;

  locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: config.serverUrl,
      dio: Dio(),
      firebaseAuth: firebaseAuth,
      sharedPrefs: locator.get<SharedPreferences>(),
    ),
  );

  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      firebaseAuth: firebaseAuth,
    ),
  );

  locator.registerLazySingleton<BusinessRepository>(
    () => BusinessRepository(
      apiClient: locator.get<ApiClient>(),
      sharedPreferences: sharedPrefs,
    ),
  );

  locator.registerLazySingleton<PrintersRepository>(
    () => PrintersRepository(
      apiClient: locator.get<ApiClient>(),
    ),
  );
}
