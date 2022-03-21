class PrintJob {
  final int id;
  final String uuid;
  final String jobType;
  final int printerId;
  final String printerName;
  final int businessId;
  final String createdAt;
  final String downloadUrl;

  PrintJob({
    required this.id,
    required this.uuid,
    required this.jobType,
    required this.printerId,
    required this.printerName,
    required this.businessId,
    required this.createdAt,
    required this.downloadUrl,
  });

  factory PrintJob.fromJson(Map json) {
    return PrintJob(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      jobType: json['jobType'],
      printerId: json['printerId'] as int,
      printerName: json['printerName'] as String,
      businessId: json['businessId'] as int,
      createdAt: json['createdAt'] as String,
      downloadUrl: json['downloadUrl'] as String,
    );
  }
}
