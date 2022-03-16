import 'package:get_it/get_it.dart';
import 'package:lura_client/core/repository/print_station_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

final locator = GetIt.instance;

Future setupLocator() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<PrintStationRepository>(
      () => PrintStationRepository());
}
