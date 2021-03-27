import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:flutter/material.dart';

class CustomizeTaskDateTimeAction {
  final Collection collection;
  final Task task;

  final int dateTime;

  CustomizeTaskDateTimeAction(this.collection, this.task, this.dateTime);
}

class CustomizeTaskLabelAction {
  final Collection collection;
  final Task task;

  final Color colorLabel;
  final String labelName;

  CustomizeTaskLabelAction(
      this.collection, this.task, this.colorLabel, this.labelName);
}

class CustomizeTaskNotesAction {
  final Collection collection;
  final Task task;

  final String note;

  CustomizeTaskNotesAction(this.collection, this.task, this.note);
}

class CustomizeTaskNameAction {
  final Collection collection;
  final Task task;

  final String taskName;

  CustomizeTaskNameAction(this.collection, this.task, this.taskName);
}

class NewTaskState {
  final Task task;
  final Collection collection;

  NewTaskState(this.task, this.collection);
}

class InsertNewTask {
  final Collection collection;
  final Task task;

  InsertNewTask(this.collection, this.task);
}
