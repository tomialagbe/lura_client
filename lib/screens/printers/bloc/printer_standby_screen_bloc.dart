import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';

class PrinterStandbyScreenState extends Equatable {
  final bool isWaiting;

  const PrinterStandbyScreenState(this.isWaiting);

  @override
  List<Object?> get props => [isWaiting];
}

class PrinterStandbyScreenBloc extends Cubit<PrinterStandbyScreenState> {
  final PrinterEmulationBloc printerEmulationBloc;
  late final StreamSubscription<PrinterEmulationState>
      _emulationStateSubscription;

  PrinterStandbyScreenBloc({required this.printerEmulationBloc})
      : super(const PrinterStandbyScreenState(true)) {
    _emulationStateSubscription =
        printerEmulationBloc.stream.listen((emulationState) {});
  }

  @override
  Future<void> close() async {
    _emulationStateSubscription.cancel();
    super.close();
  }
}
