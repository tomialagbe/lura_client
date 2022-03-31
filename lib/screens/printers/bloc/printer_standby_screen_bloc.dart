import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';

class PrinterStandbyScreenState extends Equatable {
  final bool isWaiting;
  final String? currentJobUrl;

  bool get hasJob => currentJobUrl != null;

  const PrinterStandbyScreenState(
      {required this.isWaiting, this.currentJobUrl});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [isWaiting, currentJobUrl];
}

class PrinterStandbyScreenBloc extends Cubit<PrinterStandbyScreenState> {
  final PrinterEmulationBloc printerEmulationBloc;
  late final StreamSubscription<PrinterEmulationState>
      _emulationStateSubscription;

  PrinterStandbyScreenBloc({required this.printerEmulationBloc})
      : super(const PrinterStandbyScreenState(isWaiting: true)) {
    _emulationStateSubscription =
        printerEmulationBloc.stream.listen((emulationState) {
      final isWaiting = !emulationState.hasJob;
      final newState = PrinterStandbyScreenState(
          isWaiting: isWaiting, currentJobUrl: emulationState.currentJobUrl);
      debugPrint('Printer standby state changed to $newState');
      emit(newState);
    });
  }

  @override
  Future<void> close() async {
    _emulationStateSubscription.cancel();
    super.close();
  }
}
