class Business {
  final int id;
  final String name;

  const Business({
    required this.id,
    required this.name,
  });

  factory Business.fromJson(Map json) {
    return Business(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
