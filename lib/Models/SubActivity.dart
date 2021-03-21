class SubActivity {
  final int id;
  final String title;
  final int totalDuration;

  final DateTime dateWhenStarted;
  final bool isRunning;

  SubActivity(
      {this.title,
      this.totalDuration,
      this.id,
      this.dateWhenStarted,
      this.isRunning = false});

  SubActivity copyWith({
    String title,
    int totalDuration,
    int id,
    bool isRunning,
    DateTime dateWhenStarted,
  }) {
    return SubActivity(
        id: id ?? this.id,
        title: title ?? this.title,
        totalDuration: totalDuration ?? this.totalDuration,
        dateWhenStarted: dateWhenStarted ?? this.dateWhenStarted,
        isRunning: isRunning ?? this.isRunning);
  }

  SubActivity.fromMap(Map activity)
      : id = activity['id'],
        title = activity['title'],
        totalDuration = activity['totalDuration'],
        dateWhenStarted = DateTime.fromMillisecondsSinceEpoch(
            activity['dateWhenStarted'] ??
                DateTime.now().millisecondsSinceEpoch),
        isRunning = activity['isRunning'] ?? false;

  Map<String, dynamic> toMap() => {
        'id': (id as int),
        'title': title,
        'totalDuration': totalDuration,
        'dateWhenStarted': dateWhenStarted.millisecondsSinceEpoch ?? 0,
        'isRunning': isRunning ?? false,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
