import 'package:flutter/cupertino.dart';
import 'package:lura_client/core/models/receipt.dart';

class ReceiptsViewmodel extends ChangeNotifier {
  final List<Receipt> _receipts = [
    Receipt(id: '1', dateCreated: '26th, Feb 2022', printerName: 'Printer one'),
    Receipt(id: '2', dateCreated: '11th, Mar 2022', printerName: 'Printer two'),
    Receipt(id: '3', dateCreated: '19th, Mar 2022', printerName: 'Printer one'),
  ];

  List<Receipt> get receipts => _receipts;

  ReceiptsViewmodel();
}
