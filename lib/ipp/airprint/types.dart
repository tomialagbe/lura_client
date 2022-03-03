abstract class Types {
  static int toType(String name) {
    switch (name.toUpperCase()) {
      case 'A':
        return 1;
      case 'NULL':
        return 10;
      case 'AAAA':
        return 28;
      case 'MX':
        return 15;
      case 'PTR':
        return 12;
      case 'SRV':
        return 33;
      case 'TXT':
        return 16;
      case 'ANY':
        return 255;
      case '*':
        return 255;
    }
    return 0;
  }

  static String toStr(int type) {
    switch (type) {
      case 1:
        return 'A';
      case 10:
        return 'NULL';
      case 28:
        return 'AAAA';
      case 15:
        return 'MX';
      case 12:
        return 'PTR';
      case 33:
        return 'SRV';
      case 16:
        return 'TXT';
      case 255:
        return 'ANY';
    }
    return 'UNKNOWN_$type';
  }
}
