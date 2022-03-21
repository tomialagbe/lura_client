import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/print_jobs/print_job.dart';

class PrintJobRepository {
  final ApiClient apiClient;

  const PrintJobRepository({required this.apiClient});

  Future<List<PrintJob>> getPrintJobsForBusiness(int businessId) async {
    final resp = await apiClient.get('/businesses/$businessId/jobs');
    final printJobs =
        (resp!.data as List).map((e) => PrintJob.fromJson(e)).toList();
    return printJobs;
  }
}
