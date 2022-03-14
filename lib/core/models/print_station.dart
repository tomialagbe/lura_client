import 'package:equatable/equatable.dart';

class PrintStation extends Equatable {
  final String name;
  final String platform;
  final bool online;
  final bool unused;

  PrintStation({
    required this.name,
    required this.platform,
    this.online = false,
    required this.unused,
  });

  @override
  List<Object?> get props => [name, platform, online, unused];
}
