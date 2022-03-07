class DnsQueryResponse {
  final List<DnsAnswer> questions = const [];
  final List<DnsAnswer> answers = [];
  final List<DnsAnswer> authorities = const [];
  final List<DnsAnswer> additionals = const [];
}

class DnsAnswer {
  final String name;
  final String type;
  final bool flush;
  final int ttl;
  final dynamic data;

  DnsAnswer({
    required this.name,
    required this.type,
    this.flush = false,
    required this.ttl,
    required this.data,
  });
}
