import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/printers/printer.dart';

class PrintersRepository {
  final ApiClient apiClient;

  const PrintersRepository({required this.apiClient});

  Future<List<Printer>> loadPrintersForBusiness(int businessId) async {
    final resp = await apiClient.get('/businesses/$businessId/printers');
    final printers =
        (resp!.data as List).map((e) => Printer.fromJson(e)).toList();
    return printers;
  }

  Future<Printer> savePrinter(
      int businessId, String name, String osType) async {
    final reqBody = {
      'name': name,
      'osType': osType,
      'ownerBusinessId': businessId
    };
    final resp = await apiClient.post('/printers', data: reqBody);
    final created = Printer.fromJson(resp!.data);
    return created;
  }

  Future sendPing(int printerId) async {
    await apiClient.get('/printers/$printerId/ping');
  }
}
