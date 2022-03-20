enum PrinterOsType {
  iOS,
  android,
  windows,
}

extension StringConversions on PrinterOsType {
  String get asString {
    switch (this) {
      case PrinterOsType.iOS:
        return 'IOS';
      case PrinterOsType.android:
        return 'ANDROID';
      case PrinterOsType.windows:
        return 'WINDOWS';
    }
  }
}

extension OsTypeConversions on String {
  PrinterOsType get toPrinterOsType {
    switch (toLowerCase()) {
      case 'windows':
        return PrinterOsType.windows;
      case 'android':
        return PrinterOsType.android;
      case 'ios':
      default:
        return PrinterOsType.iOS;
    }
  }
}

class Printer {
  final int id;
  final String name;
  final int ownerBusinessId;
  final bool isOnline;
  final PrinterOsType osType;
  final bool isUnused;

  Printer({
    required this.id,
    required this.name,
    required this.ownerBusinessId,
    required this.isOnline,
    required this.osType,
    required this.isUnused,
  });

  @override
  String toString() {
    return 'Printer {id: $id, name: $name, ownerBusinessId: $ownerBusinessId,'
        ' isOnline: $isOnline, osType: $osType, isUnused: $isUnused}';
  }

  factory Printer.fromJson(Map json) {
    return Printer(
      id: json['id'] as int,
      name: json['name'] as String,
      ownerBusinessId: json['ownerBusinessId'] as int,
      osType: (json['osType'] as String).toPrinterOsType,
      isOnline: json['isOnline'] as bool,
      isUnused: json['isUnused'] as bool,
    );
  }
}
