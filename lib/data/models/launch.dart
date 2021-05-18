import 'package:intl/intl.dart';

class Launch {
  final String id;
  final String name;
  final DateTime launchTimeUTC;
  final DateFormat _dateFormat = DateFormat('MMMM d HH:mm');

  Launch({required this.id, required this.name, required this.launchTimeUTC});

  String get formattedLocalDate => _dateFormat.format(launchTimeUTC.toLocal());

  factory Launch.fromMap(Map<String, dynamic> map) {
    return Launch(
      id: map['id'],
      name: map['name'],
      launchTimeUTC: DateTime.parse(map['date_utc']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date_utc': launchTimeUTC,
    };
  }
}
