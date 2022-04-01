import 'package:uuid/uuid.dart';

// See https://wiki.debian.org/CUPSAirPrint
Map<String, String> airPrintAttributes() => {
      'air': 'none',
      'note': '',
      'pdl':
          'application/vnd.hp-PCL,image/jpeg,application/postscript,application/PCLm,image/urf',
      //application/vnd.hp-PCL,image/jpeg,application/PCLm,image/urf
      // 'pdl': ['image/urf'],
      'rp': 'ipp/print',
      'TLS': '',
      // 'UUID': const Uuid().v4(),
      'UUID': '2cb091b7-8118-411e-85d8-2b16a3099c47',
      // This needs to be static, or else, the client OS won't be able to find the printer after consecutive restarts

      //Deprecated Options
      'adminurl': '',
      'priority': '50',
      'product': '(Lura)',
      'qtotal': '1',
      'txtvers': '1',
      'ty': 'Lura',
      'usb_CMD': '',
      'usb_MDL': '',
      'usb_MFG': '',

      //AirPrint Specific Options
      'URF': 'DM3',
      // 'URF': 'CP1,MT1-2-8-9-10-11,OB9,OFU0,PQ3-4-5,RS300-600,SRGB24,W8-16,DEVW8-16,DEVRGB24-48,ADOBERGB24-48,DM3,IS1,V1.3',

      // 9.3 Printer Capability TXT Record Keys
      'Transparent': 'F',
      'Binary': 'F',
      'TBCP': 'F',
      'kind': 'document,envelope,photo',
      // document,envelope,photo
      // 'kind': ['document', 'photo'],

      // 9.4 Printer Feature TXT Record Keys
      'Color': 'T',
      // TODO
      'Duplex': 'U',
      'PaperMax': 'legal-A4',
      'Staple': 'U',

      //Deprecated features
      'Bind': 'U',
      'Collate': 'U',
      'Copies': 'U',
      'PaperCustom': 'U',
      'Punch': 'U',
      'Scan': 'F',
      'Sort': 'U'
    };
