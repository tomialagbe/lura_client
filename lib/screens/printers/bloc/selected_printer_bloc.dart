import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/printers/printer.dart';

class SelectedPrinterBloc extends Cubit<Printer?> {
  SelectedPrinterBloc() : super(null);

  void setSelectedPrinter(Printer printer) {
    debugPrint('Setting selected printer to $printer');
    emit(printer);
  }

  void clearSelectedPrinter() {
    emit(null);
  }
}
