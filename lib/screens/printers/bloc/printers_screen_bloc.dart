import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:lura_client/core/business/model.dart';
import 'package:lura_client/core/printers/printer.dart';
import 'package:lura_client/core/printers/printers_repository.dart';
import 'package:lura_client/locator.dart';

class PrintersScreenState extends Equatable {
  final bool loading;
  final List<Printer> printers;
  final String? loadError;

  const PrintersScreenState({
    required this.loading,
    required this.printers,
    required this.loadError,
  });

  const PrintersScreenState._(
      {this.loading = true, this.printers = const [], this.loadError});

  const PrintersScreenState.initial() : this._();

  PrintersScreenState loaded(List<Printer> printers) => PrintersScreenState._(
      loading: false, printers: printers, loadError: null);

  PrintersScreenState loadFailed(String error) =>
      PrintersScreenState._(loading: false, loadError: error);

  @override
  List<Object?> get props => [loading, printers, loadError];
}

class PrintersScreenBloc extends Cubit<PrintersScreenState> {
  final PrintersRepository printersRepository;
  final BusinessBloc businessBloc;

  late final StreamSubscription<Business?> _businessStateSubscription;

  Business? _business;

  Business? get business => _business;

  PrintersScreenBloc(
      {PrintersRepository? printersRepo, required this.businessBloc})
      : printersRepository = printersRepo ?? locator.get<PrintersRepository>(),
        super(const PrintersScreenState.initial()) {
    _businessStateSubscription = businessBloc.stream.listen((business) {
      if (business != null) {
        _business = business;
        loadPrinters();
      }
    });
  }

  Future loadPrinters() async {
    if (_business == null) {
      return;
    }

    try {
      if (state != const PrintersScreenState.initial()) {
        emit(const PrintersScreenState.initial());
      }
      final printers =
          await printersRepository.loadPrintersForBusiness(_business!.id);
      emit(state.loaded(printers));
    } on ResponseException catch (err) {
      emit(state.loadFailed(err.responseMessage ?? err.message));
    } catch (err) {
      emit(state
          .loadFailed('Failed to load printers. An unknown error occurred.'));
    }
  }

  @override
  Future<void> close() async {
    _businessStateSubscription.cancel();
    return super.close();
  }
}
