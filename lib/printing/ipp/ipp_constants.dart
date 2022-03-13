// ignore_for_file = constant_identifier_names

abstract class IppConstants {
  // Values
  static const int FALSE = 0x00;
  static const int TRUE = 0x01;

  // Operation Ids
  static const int PRINT_JOB = 0x02;
  static const int PRINT_URI = 0x03;
  static const int VALIDATE_JOB = 0x04;
  static const int CREATE_JOB = 0x05;
  static const int SEND_DOCUMENT = 0x06;
  static const int SEND_URI = 0x07;
  static const int CANCEL_JOB = 0x08;
  static const int GET_JOB_ATTRIBUTES = 0x09;
  static const int GET_JOBS = 0x0a;
  static const int GET_PRINTER_ATTRIBUTES = 0x0b;
  static const int HOLD_JOB = 0x0c;
  static const int RELEASE_JOB = 0x0d;
  static const int RESTART_JOB = 0x0e;
  static const int PAUSE_PRINTER = 0x10;
  static const int RESUME_PRINTER = 0x11;
  static const int PURGE_JOBS = 0x12;

  // Delimiter Tags
  static const int OPERATION_ATTRIBUTES_TAG = 0x01;
  static const int JOB_ATTRIBUTES_TAG = 0x02;
  static const int END_OF_ATTRIBUTES_TAG = 0x03;
  static const int PRINTER_ATTRIBUTES_TAG = 0x04;
  static const int UNSUPPORTED_ATTRIBUTES_TAG = 0x05;

  // Value Tags (out-of-band)
  static const int UNSUPPORTED = 0x10;
  static const int UNKNOWN = 0x12;
  static const int NO_VALUE = 0x13;

  // Value Tags (integer)
  static const int INTEGER = 0x21;
  static const int BOOLEAN = 0x22;
  static const int ENUM = 0x23;

  // Value Tags (octet-string)
  static const int OCTET_STRING = 0x30; // with unspecified format
  static const int DATE_TIME = 0x31;
  static const int RESOLUTION = 0x32;
  static const int RANGE_OF_INTEGER = 0x33;
  static const int TEXT_WITH_LANG = 0x35;
  static const int NAME_WITH_LANG = 0x36;

  // Value Tags (character-string)
  static const int TEXT_WITHOUT_LANG = 0x41;
  static const int NAME_WITHOUT_LANG = 0x42;
  static const int KEYWORD = 0x44;
  static const int URI = 0x45;
  static const int URI_SCHEME = 0x46;
  static const int CHARSET = 0x47;
  static const int NATURAL_LANG = 0x48;
  static const int MIME_MEDIA_TYPE = 0x49;

  // Successful Status Codes
  static const int SUCCESSFUL_OK = 0x0000;
  static const int SUCCESSFUL_OK_IGNORED_OR_SUBSTITUTED_ATTRIBUTES = 0x0001;
  static const int SUCCESSFUL_OK_CONFLICTING_ATTRIBUTES = 0x0002;

  // Client Error Status Codes
  static const int CLIENT_ERROR_BAD_REQUEST = 0x0400;
  static const int CLIENT_ERROR_FORBIDDEN = 0x0401;
  static const int CLIENT_ERROR_NOT_AUTHENTICATED = 0x0402;
  static const int CLIENT_ERROR_NOT_AUTHORIZED = 0x0403;
  static const int CLIENT_ERROR_NOT_POSSIBLE = 0x0404;
  static const int CLIENT_ERROR_TIMEOUT = 0x0405;
  static const int CLIENT_ERROR_NOT_FOUND = 0x0406;
  static const int CLIENT_ERROR_GONE = 0x0407;
  static const int CLIENT_ERROR_REQUEST_ENTITY_TOO_LARGE = 0x0408;
  static const int CLIENT_ERROR_REQUEST_VALUE_TOO_LONG = 0x0409;
  static const int CLIENT_ERROR_DOCUMENT_FORMAT_NOT_SUPPORTED = 0x040a;
  static const int CLIENT_ERROR_ATTRIBUTES_OR_VALUES_NOT_SUPPORTED = 0x040b;
  static const int CLIENT_ERROR_URI_SCHEME_NOT_SUPPORTED = 0x040c;
  static const int CLIENT_ERROR_CHARSET_NOT_SUPPORTED = 0x040d;
  static const int CLIENT_ERROR_CONFLICTING_ATTRIBUTES = 0x040e;
  static const int CLIENT_ERROR_COMPRESSION_NOT_SUPPORTED = 0x040f;
  static const int CLIENT_ERROR_COMPRESSION_ERROR = 0x0410;
  static const int CLIENT_ERROR_DOCUMENT_FORMAT_ERROR = 0x0411;
  static const int CLIENT_ERROR_DOCUMENT_ACCESS_ERROR = 0x0412;

  // Server Error Status Codes
  static const int SERVER_ERROR_INTERNAL_ERROR = 0x0500;
  static const int SERVER_ERROR_OPERATION_NOT_SUPPORTED = 0x0501;
  static const int SERVER_ERROR_SERVICE_UNAVAILABLE = 0x0502;
  static const int SERVER_ERROR_VERSION_NOT_SUPPORTED = 0x0503;
  static const int SERVER_ERROR_DEVICE_ERROR = 0x0504;
  static const int SERVER_ERROR_TEMPORARY_ERROR = 0x0505;
  static const int SERVER_ERROR_NOT_ACCEPTING_JOBS = 0x0506;
  static const int SERVER_ERROR_BUSY = 0x0507;
  static const int SERVER_ERROR_JOB_CANCELED = 0x0508;
  static const int SERVER_ERROR_MULTIPLE_DOCUMENT_JOBS_NOT_SUPPORTED = 0x0509;

  // Printer states
  static const int PRINTER_IDLE = 3;
  static const int PRINTER_PROCESSING = 4;
  static const int PRINTER_STOPPED = 5;

  // Job states
  static const int JOB_PENDING = 3;
  static const int JOB_PENDING_HELD = 4;
  static const int JOB_PROCESSING = 5;
  static const int JOB_PROCESSING_STOPPED = 6;
  static const int JOB_CANCELED = 7;
  static const int JOB_ABORTED = 8;
  static const int JOB_COMPLETED = 9;
}
