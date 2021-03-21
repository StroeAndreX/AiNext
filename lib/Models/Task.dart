import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;

  final bool isCompleted;
  final List<String> notes;

  final Color colorLabel;
  final String label;
  final int dateTime;

  Task(
      {this.title,
      this.notes,
      this.id,
      this.isCompleted = false,
      this.colorLabel = Colors.transparent,
      this.label,
      this.dateTime = -1});

  Task copyWith(
      {String title,
      List<String> notes,
      int id,
      bool isCompleted,
      Color colorLabel,
      String label,
      int dateTime}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        notes: notes ?? this.notes,
        isCompleted: isCompleted ?? this.isCompleted,
        colorLabel: colorLabel ?? this.colorLabel,
        label: label ?? this.label,
        dateTime: dateTime ?? this.dateTime);
  }

  Task.fromMap(Map task)
      : id = task['id'],
        title = task['title'],
        notes = [],
        isCompleted = task['isCompleted'] ?? false,
        colorLabel = Color(task['colorLabel'] ?? Colors.transparent),
        label = task['label'],
        dateTime = task['dateTime'] ?? -1;

  Map<String, dynamic> toMap() => {
        'id': (id as int),
        'title': title,
        'notes': notes,
        'isCompleted': isCompleted,
        'colorLabel': colorLabel.value,
        'dateTime': dateTime,
        'label': label,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
