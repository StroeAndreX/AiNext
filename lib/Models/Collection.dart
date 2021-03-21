import 'dart:convert';

import 'package:AiOrganization/Models/Task.dart';
import 'package:flutter/material.dart';

enum CollectionType {
  CALENDAR,
  CREATED,
}

class Collection {
  final int id;
  final String title;
  final List<Task> tasks;

  final CollectionType collectionType;
  final IconData iconData;
  final Color color;

  Collection(
      {this.id,
      this.title,
      this.tasks,
      this.collectionType,
      this.color,
      this.iconData});

  Collection copyWith(
      {String title,
      List<Task> tasks,
      int id,
      CollectionType collectionType,
      IconData iconData,
      Color color}) {
    return Collection(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
      collectionType: collectionType ?? this.collectionType,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
    );
  }

  Collection.fromMap(Map collection, List<Task> collectionTasks)
      : id = collection['id'],
        tasks = collectionTasks,
        title = collection['title'],
        collectionType =
            CollectionType.values[collection['collectionType'] as int],
        iconData =
            IconData(collection['iconData'], fontFamily: 'MaterialIcons'),
        color = Color(collection['color']);

  Collection fromJson(Map collection) {
    List<dynamic> dynamicTask = jsonDecode(collection['tasks']);
    List<Task> collectionTask =
        (dynamicTask).map((i) => Task.fromMap(i)).toList();

    return Collection(
        id: collection['id'],
        tasks: collectionTask,
        title: collection['title'],
        collectionType:
            CollectionType.values[collection['collectionType'] as int],
        iconData: collection['iconData'],
        color: collection['color']);
  }

  Map<String, dynamic> toMap() => {
        'id': (id as int),
        'tasks': jsonEncode(tasks.map((e) => e.toMap()).toList()),
        'title': title,
        "collectionType": (collectionType.index as int),
        "iconData": iconData.codePoint,
        "color": color.value,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
