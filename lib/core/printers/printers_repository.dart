import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/printers/dto.dart';
import 'package:lura_client/core/printers/printer.dart';
import 'package:lura_client/core/printing/esc/models.dart';

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
    debugPrint('Sending printer ping');
    await apiClient.get('/printers/$printerId/ping');
  }

  /// jobType -> POSTSCRIPT, ESCPOS
  Future<NewPrintJobResponse?> createPrintJob(
      int printerId, String jobType) async {
    final body = {'type': jobType};
    final resp = await apiClient.post('/printers/$printerId/jobs', data: body);
    final printJobResponse = NewPrintJobResponse.fromJson(resp!.data);
    return printJobResponse;
  }

  Future uploadEscPrintJob(
      String jobId, String jobUri, List<PrintToken> tokens) async {
    try {
      final body = {
        'jobId': jobId,
        'tokens': tokens.map((e) => e.toJson()).toList(),
      };
      await apiClient.postUri(jobUri, data: jsonEncode(body));
    } catch (err) {
      // TODO: handle errors
    }
  }

  Future uploadPostscriptPrintJob(
      String jobId, String jobUri, Uint8List data) async {
    try {
      final body = {
        'jobId': jobId,
        'data': data,
      };
      await apiClient.postUri(jobUri, data: jsonEncode(body));
    } catch (err) {
      // TODO: handle errors
    }
  }
}
