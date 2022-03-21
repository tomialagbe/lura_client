import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/authentication/authentication_repository.dart';
import 'package:lura_client/core/business/business_repository.dart';
import 'package:lura_client/locator.dart';

import '../authentication/lura_user.dart';
import 'model.dart';

class BusinessBloc extends Cubit<Business?> {
  static const noBusiness = Business(id: 0, name: '');
  final BusinessRepository businessRepository;
  final AuthenticationRepository authenticationRepository;

  BusinessBloc(
      {BusinessRepository? businessRepo, AuthenticationRepository? authRepo})
      : businessRepository = businessRepo ?? locator.get<BusinessRepository>(),
        authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        super(null) {
    authenticationRepository.user.listen((user) {
      if (user != LuraUser.empty) {
        debugPrint(
            'Loading business UID: ${user.uid}, email: ${user.email} Display name: ${user.displayName}');
        loadBusiness();
      }
    });
  }

  Future loadBusiness() async {
    try {
      final business = await businessRepository.getBusinessForUser();
      if (business == null) {
        debugPrint('NO business');
        emit(noBusiness);
      } else {
        debugPrint('Found business ${business.name}');
        emit(business);
      }
    } on ResponseException catch (rex) {
      // TODO: show error popup
      debugPrint(rex.toString());
    } on TimeoutException catch (e) {
      // TODO: show error popup
      debugPrint(e.toString());
    }
  }
}
