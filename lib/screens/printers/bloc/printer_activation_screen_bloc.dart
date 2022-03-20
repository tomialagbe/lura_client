import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';

class PrinterActivationScreenState extends Equatable {
  final bool isLoading;
  final bool isCompleted;

  const PrinterActivationScreenState._(
      {this.isLoading = true, this.isCompleted = false});

  const PrinterActivationScreenState.initial() : this._();

  PrinterActivationScreenState loading() =>
      const PrinterActivationScreenState._(isLoading: true, isCompleted: false);

  PrinterActivationScreenState success() =>
      const PrinterActivationScreenState._(isLoading: false, isCompleted: true);

  @override
  List<Object?> get props => [isLoading, isCompleted];
}

class PrinterActivationScreenBloc extends Cubit<PrinterActivationScreenState> {
  final SelectedPrinterBloc selectedPrinterBloc;
  final PrinterEmulationBloc printerEmulationBloc;

  late final StreamSubscription<PrinterEmulationState> _peBlocSubscription;

  PrinterActivationScreenBloc({
    required this.selectedPrinterBloc,
    required this.printerEmulationBloc,
  }) : super(const PrinterActivationScreenState.initial()) {
    _peBlocSubscription = printerEmulationBloc.stream.listen((emulationState) {
      if (emulationState.isConnecting) {
        emit(state.loading());
      } else if (emulationState.allOnline) {
        emit(state.success());
      }
    });
    activatePrinter();
  }

  void activatePrinter() {
    if (selectedPrinterBloc.state == null) {
      return;
    }

    printerEmulationBloc.startEmulation();
  }

  @override
  Future<void> close() async {
    _peBlocSubscription.cancel();
    super.close();
  }
}
