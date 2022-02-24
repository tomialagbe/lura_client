import 'dart:typed_data';

class IppMessage {
  int? versionMajor;
  int? versionMinor;
  int? operationIdOrStatusCode;
  int? requestId;
  List<AttributeGroup> groups = [];
  Uint8List? data;
}

class AttributeGroup {
  int? tag;
  List<Attribute> attributes = [];
}

class Attribute {
  int? tag;
  String? name;
  List<dynamic> value = [];

  Attribute();

  Attribute.from({this.tag, this.name, this.value = const []});
}
