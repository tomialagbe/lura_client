import 'package:equatable/equatable.dart';

class Receipt extends Equatable {
  final String id;
  final String dateCreated;
  final String printerName;

  const Receipt({
    required this.id,
    required this.dateCreated,
    required this.printerName,
  });

  @override
  List<Object?> get props => [id, dateCreated, printerName];
}
