import 'dart:convert';

import 'package:AiOrganization/Models/SubActivity.dart';

class Activity {
  final int id;
  final String title;
  final int totalDuration;

  final List<SubActivity> subActivities;
  final DateTime dateWhenStarted;
  final bool isRunning;

  Activity(
      {this.title,
      this.totalDuration,
      this.id,
      this.subActivities,
      this.dateWhenStarted,
      this.isRunning = false});

  Activity copyWith({
    String title,
    int totalDuration,
    int id,
    List<SubActivity> subActivities,
    bool isRunning,
    DateTime dateWhenStarted,
  }) {
    return Activity(
        id: id ?? this.id,
        title: title ?? this.title,
        totalDuration: totalDuration ?? this.totalDuration,
        subActivities: subActivities ?? this.subActivities,
        dateWhenStarted: dateWhenStarted ?? this.dateWhenStarted,
        isRunning: isRunning ?? this.isRunning);
  }

  Activity.fromMap(Map activity, List<SubActivity> subActivities)
      : id = activity['id'],
        title = activity['title'],
        totalDuration = activity['totalDuration'],
        subActivities = subActivities,
        dateWhenStarted = DateTime.fromMillisecondsSinceEpoch(
            activity['dateWhenStarted'] ??
                DateTime.now().millisecondsSinceEpoch),
        isRunning = activity['isRunning'];

  Map<String, dynamic> toMap() => {
        'id': (id as int),
        'title': title,
        'totalDuration': totalDuration,
        'subActivities':
            jsonEncode(subActivities.map((e) => e.toMap()).toList()),
        'dateWhenStarted': dateWhenStarted.millisecondsSinceEpoch ?? 0,
        'isRunning': isRunning ?? false,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
