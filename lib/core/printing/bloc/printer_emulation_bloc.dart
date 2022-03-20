import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/printers/printers_repository.dart';
import 'package:lura_client/core/printing/esc/esc_pos_printer_emulator.dart';
import 'package:lura_client/core/printing/ipp/ipp_printer_emulator.dart';
import 'package:lura_client/core/utils/platform_helper.dart';
import 'package:lura_client/locator.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';

import '../esc/models.dart';

abstract class PrinterConnectionDetails extends Equatable {
  final String ipAddress;
  final String port;
  final String name;

  const PrinterConnectionDetails({
    required this.ipAddress,
    required this.port,
    required this.name,
  });

  @override
  List<Object?> get props => [ipAddress, port, name];
}

class IppConnectionDetails extends PrinterConnectionDetails {
  final bool airprintEnabled;

  const IppConnectionDetails({
    required this.airprintEnabled,
    required String ipAddress,
    required String port,
    required String name,
  }) : super(ipAddress: ipAddress, port: port, name: name);

  @override
  List<Object?> get props => [...super.props, airprintEnabled];
}

class EscPosConnectionDetails extends PrinterConnectionDetails {
  const EscPosConnectionDetails({
    required String ipAddress,
    required String port,
    required String name,
  }) : super(ipAddress: ipAddress, port: port, name: name);
}

class PrinterEmulationState extends Equatable {
  final bool isConnecting;
  final IppConnectionDetails? ippConnectionDetails;
  final EscPosConnectionDetails? escPosConnectionDetails;

  const PrinterEmulationState._({
    this.ippConnectionDetails,
    this.escPosConnectionDetails,
    this.isConnecting = true,
  });

  const PrinterEmulationState.stopped() : this._();

  PrinterEmulationState connecting() => PrinterEmulationState._(
        ippConnectionDetails: ippConnectionDetails,
        escPosConnectionDetails: escPosConnectionDetails,
        isConnecting: true,
      );

  PrinterEmulationState ippStarted(IppConnectionDetails ippConnectionDetails) =>
      PrinterEmulationState._(
        ippConnectionDetails: ippConnectionDetails,
        escPosConnectionDetails: escPosConnectionDetails,
        isConnecting: escPosConnectionDetails == null,
      );

  PrinterEmulationState escPosStarted(
          EscPosConnectionDetails escPosConnectionDetails) =>
      PrinterEmulationState._(
        escPosConnectionDetails: escPosConnectionDetails,
        ippConnectionDetails: ippConnectionDetails,
        isConnecting: ippConnectionDetails == null,
      );

  bool get allOnline =>
      ippConnectionDetails != null && escPosConnectionDetails != null;

  @override
  List<Object?> get props =>
      [ippConnectionDetails, escPosConnectionDetails, isConnecting];
}

class PrinterEmulationBloc extends Cubit<PrinterEmulationState> {
  final SelectedPrinterBloc selectedPrinterBloc;
  final PrintersRepository printersRepository;

  IppPrinterEmulator? _ippPrinterEmulator;
  EscPosPrinterEmulator? _escPosPrinterEmulator;

  PrinterEmulationBloc({
    PrintersRepository? printersRepo,
    required this.selectedPrinterBloc,
  })  : printersRepository = printersRepo ?? locator.get<PrintersRepository>(),
        super(const PrinterEmulationState.stopped()) {}

  void startEmulation() async {
    if (selectedPrinterBloc.state == null) {
      throw Exception('No printer has been selected');
    }

    emit(state.connecting());
    final ippConnectionDetails = await _startIppEmulation();
    emit(state.ippStarted(ippConnectionDetails));
    final escPosConnectionDetails = await _startEscPosEmulation();
    emit(state.escPosStarted(escPosConnectionDetails));
  }

  void stopEmulation() async {
    _pingTimer?.cancel();
    await _ippPrinterEmulator?.stop();
    await _escPosPrinterEmulator?.stop();
    emit(const PrinterEmulationState.stopped());
  }

  Timer? _pingTimer;

  void enterStandbyMode() {
    if (selectedPrinterBloc.state == null) {
      return;
    }
    final printer = selectedPrinterBloc.state!;
    printersRepository.sendPing(printer.id);
    _pingTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) {
        printersRepository.sendPing(printer.id);
      },
    );
  }

  Future<IppConnectionDetails> _startIppEmulation() async {
    final printer = selectedPrinterBloc.state!;
    final port = PlatformHelper.isAndroid ? 9000 : 631;

    _ippPrinterEmulator =
        IppPrinterEmulator(name: printer.name, port: port, useAirprint: true);
    await _ippPrinterEmulator?.start();
    _ippPrinterEmulator?.onPrintEnd = _handleIppPrintJob;

    return IppConnectionDetails(
        airprintEnabled: _ippPrinterEmulator!.useAirprint,
        ipAddress: await _getDeviceIp(),
        port: '${_ippPrinterEmulator!.port}',
        name: printer.name);
  }

  Future<EscPosConnectionDetails> _startEscPosEmulation() async {
    final printer = selectedPrinterBloc.state!;
    _escPosPrinterEmulator = EscPosPrinterEmulator(name: printer.name);
    await _escPosPrinterEmulator?.start();
    _escPosPrinterEmulator?.onPrintEnd = _handleEscPosPrintJob;
    return EscPosConnectionDetails(
        ipAddress: await _getDeviceIp(),
        port: '${_escPosPrinterEmulator!.port}',
        name: printer.name);
  }

  void _handleIppPrintJob(Uint8List printData) async {}

  void _handleEscPosPrintJob(List<PrintToken> tokens) async {}

  Future<String> _getDeviceIp() async {
    final interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);
    final address = interfaces[0].addresses[0];
    return address.address;
  }

  @override
  Future<void> close() async {
    _pingTimer?.cancel();
    await _ippPrinterEmulator?.stop();
    await _escPosPrinterEmulator?.stop();
    super.close();
  }
}
