import 'package:flutter/material.dart';

class Event {
  final int? id;
  final String name;
  final String description;
  final String location;
  final String time;
  final int color;
  final DateTime dateTime;
  final String endTime;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.time,
    required this.color,
    required this.dateTime,
    required this.endTime,
  });

  Color get colorAsColor => Color(color);
}
