import 'dart:typed_data';

class IppMessage {
  int? versionMajor;
  int? versionMinor;
  int? operationIdOrStatusCode;
  int? requestId;
  List<AttributeGroup> groups = [];
  Uint8List? data;

  @override
  String toString() {
    return 'IppMessage {versionMajor: $versionMajor, versionMinor: $versionMinor, '
        'operationIdOrStatusCode: $operationIdOrStatusCode, requestId: $requestId, '
        'groups: [\n${groups.map((e) => e.toString() + ',\n')}]';
  }
}

class AttributeGroup {
  int? tag;
  List<Attribute> attributes = [];

  @override
  String toString() {
    return 'AttributeGroup {'
        'tag: $tag,'
        'attributes: [${attributes.map((e) => e.toString())}]'
        '}';
  }
}

class Attribute {
  int? tag;
  String? name;
  List<dynamic> value = [];

  Attribute();

  Attribute.from({this.tag, this.name, this.value = const []});

  @override
  String toString() {
    return 'Attribute {tag: $tag, name: $name, value: ${value.toString()}';
  }
}
