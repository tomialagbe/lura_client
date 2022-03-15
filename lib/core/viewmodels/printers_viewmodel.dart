import 'package:flutter/material.dart';
import 'package:mobile_printer/core/models/print_station.dart';
import 'package:mobile_printer/core/repository/print_station_repository.dart';
import 'package:mobile_printer/locator.dart';

class PrintersViewmodel extends ChangeNotifier {
  final PrintStationRepository printStationRepository;

  final List<PrintStation> _printers = [];

  List<PrintStation> get printers => _printers;

  PrintersViewmodel({PrintStationRepository? printStationRepo})
      : printStationRepository =
            printStationRepo ?? locator.get<PrintStationRepository>() {
    _loadPrinters();
  }

  void _loadPrinters() async {
    final loadedPrinters = await printStationRepository.getAllPrintStations();
    _printers
      ..clear()
      ..addAll(loadedPrinters);
    notifyListeners();
  }

  Future addPrinter(String name, String platform) async {
    final ps = PrintStation(name: name, platform: platform.toLowerCase());
    await printStationRepository.addPrintStation(ps);
    _loadPrinters();
  }
}
