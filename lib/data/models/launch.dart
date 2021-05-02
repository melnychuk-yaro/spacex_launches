class Launch {
  final String name;
  final String dateTime;

  Launch({required this.name, required this.dateTime});

  factory Launch.fromMap(Map<String, dynamic> map) {
    return Launch(name: map['name'], dateTime: map['date_utc']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'date_utc': dateTime};
  }
}
