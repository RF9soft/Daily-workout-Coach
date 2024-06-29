import 'dart:convert';

class Workout {
  final String name;
  final DateTime date;
  final int duration;

  Workout({required this.name, required this.date, required this.duration});

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toIso8601String(),
    'duration': duration,
  };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Workout.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Workout.fromJson(json);
  }
}
