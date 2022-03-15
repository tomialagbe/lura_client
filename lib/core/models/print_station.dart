import 'package:equatable/equatable.dart';

class PrintStation extends Equatable {
  final String name;
  final String platform;
  final bool online;
  final bool unused;

  const PrintStation({
    required this.name,
    required this.platform,
    this.online = false,
    this.unused = false,
  });

  @override
  List<Object?> get props => [name, platform, online, unused];
}
