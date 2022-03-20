import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/printers/printers_repository.dart';
import 'package:lura_client/locator.dart';
import 'package:lura_client/screens/printers/bloc/printers_screen_bloc.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';

class CreatePrinterScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const CreatePrinterScreenState({
    required this.isSubmitting,
    required this.completed,
    required this.error,
  });

  const CreatePrinterScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const CreatePrinterScreenState.initial() : this._();

  CreatePrinterScreenState submitting() =>
      const CreatePrinterScreenState._(isSubmitting: true);

  CreatePrinterScreenState success() =>
      const CreatePrinterScreenState._(isSubmitting: false, completed: true);

  CreatePrinterScreenState failed(String message) => CreatePrinterScreenState._(
      isSubmitting: false, completed: false, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

class CreatePrinterScreenBloc extends Cubit<CreatePrinterScreenState> {
  final PrintersRepository printersRepository;
  final PrintersScreenBloc printersScreenBloc;
  final SelectedPrinterBloc selectedPrinterBloc;

  CreatePrinterScreenBloc({
    PrintersRepository? printersRepo,
    required this.printersScreenBloc,
    required this.selectedPrinterBloc,
  })  : printersRepository = printersRepo ?? locator.get<PrintersRepository>(),
        super(const CreatePrinterScreenState.initial());

  void savePrinter(String name, String platform) async {
    if (printersScreenBloc.business == null) {
      return;
    }
    try {
      emit(state.submitting());
      final businessId = printersScreenBloc.business!.id;
      final createdPrinter = await printersRepository.savePrinter(
          businessId, name, platform.toUpperCase());
      unawaited(printersScreenBloc.loadPrinters());
      selectedPrinterBloc.setSelectedPrinter(createdPrinter);
      emit(state.success());
    } on ResponseException catch (ex) {
      emit(state.failed(ex.responseMessage ?? ex.message));
    } catch (err) {
      emit(state.failed('An unknown error occurred'));
    }
  }
}
