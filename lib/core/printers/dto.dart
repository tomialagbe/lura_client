import 'package:equatable/equatable.dart';

class NewPrintJobResponse extends Equatable {
  final String jobUuid;
  final String jobDataUploadUrl;
  final String jobDownloadUrl;

  const NewPrintJobResponse({
    required this.jobUuid,
    required this.jobDataUploadUrl,
    required this.jobDownloadUrl,
  });

  factory NewPrintJobResponse.fromJson(Map json) {
    return NewPrintJobResponse(
      jobUuid: json['jobUuid'] as String,
      jobDataUploadUrl: json['jobDataUploadUrl'] as String,
      jobDownloadUrl: json['jobDownloadUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [jobUuid, jobDataUploadUrl, jobDownloadUrl];
}
