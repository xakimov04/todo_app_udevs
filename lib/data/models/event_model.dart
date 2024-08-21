import 'package:todo_app_udevs/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    super.id,
    required super.name,
    required super.description,
    required super.location,
    required super.time,
    required super.color,
    required super.dateTime,
    required super.endTime,
  });

  factory EventModel.fromMap(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      time: json['time'] as String,
      endTime: json['endTime'] as String,
      color: int.parse(json['color'] as String),
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'time': time,
      'color': color.toString(), // color ni String sifatida saqlash
      'dateTime': dateTime.toIso8601String(),
      'endTime' : endTime,
    };
  }
}
