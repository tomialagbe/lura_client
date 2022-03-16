import 'package:lura_client/core/models/print_station.dart';

class PrintStationRepository {
  final _tmpPrintStations = <PrintStation>[
    PrintStation(name: 'Cashier one', platform: 'windows'),
    PrintStation(name: 'Cashier two', platform: 'windows', unused: true),
    PrintStation(name: 'Cashier three', platform: 'android', online: true),
    PrintStation(name: 'Cashier four', platform: 'ios'),
  ];

  Future<List<PrintStation>> getAllPrintStations() async {
    return _tmpPrintStations;
  }

  Future addPrintStation(PrintStation printStation) async {
    _tmpPrintStations.add(printStation);
  }
}
