import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/api/exceptions.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:lura_client/core/business/model.dart';
import 'package:lura_client/core/print_jobs/print_job.dart';
import 'package:lura_client/core/print_jobs/print_job_repository.dart';
import 'package:lura_client/locator.dart';

class ReceiptsScreenState extends Equatable {
  final bool loading;
  final List<PrintJob> receipts;
  final String? loadError;

  const ReceiptsScreenState({
    required this.loading,
    required this.receipts,
    required this.loadError,
  });

  const ReceiptsScreenState._(
      {this.loading = true, this.receipts = const [], this.loadError});

  const ReceiptsScreenState.initial() : this._();

  ReceiptsScreenState loaded(List<PrintJob> receipts) => ReceiptsScreenState._(
      loading: false, receipts: receipts, loadError: null);

  ReceiptsScreenState loadFailed(String error) =>
      ReceiptsScreenState._(loading: false, loadError: error);

  @override
  List<Object?> get props => [loading, receipts, loadError];
}

class ReceiptsScreenBloc extends Cubit<ReceiptsScreenState> {
  final PrintJobRepository printJobRepository;
  final int businessId;

  ReceiptsScreenBloc(
      {PrintJobRepository? printJobRepo, required this.businessId})
      : printJobRepository = printJobRepo ?? locator.get<PrintJobRepository>(),
        super(const ReceiptsScreenState.initial()) {
    loadReceipts();
  }

  Future loadReceipts() async {
    try {
      if (state != const ReceiptsScreenState.initial()) {
        emit(const ReceiptsScreenState.initial());
      }
      final printJobs =
          await printJobRepository.getPrintJobsForBusiness(businessId);
      emit(state.loaded(printJobs));
    } on ResponseException catch (err) {
      emit(state.loadFailed(err.responseMessage ?? err.message));
    } catch (err) {
      emit(state
          .loadFailed('Failed to load printers. An unknown error occurred.'));
    }
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
