class Subject {
  Subject({
    required this.id,
    required this.semesterId,
    required this.name,
    required this.code,
  });

  final String id;
  final String semesterId;
  final String name;
  final String code;

  // TODO: Add Hive adapter/serialization support.
}
