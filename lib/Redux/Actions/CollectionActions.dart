import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:flutter/material.dart';

class NewCollectionAction {
  String collectionName;
  CollectionType collectionType;
  Task task;

  NewCollectionAction(this.collectionName, this.collectionType, this.task);
}

class NewEmptyCollectionAction {
  String collectionName;

  NewEmptyCollectionAction(this.collectionName);
}

/// [Collection Customization Section ]

class CustomizeCollectionNameAction {
  final Collection collection;
  final String newCollectionName;

  CustomizeCollectionNameAction(this.collection, this.newCollectionName);
}

class CustomizeCollectionColorAction {
  final Collection collection;
  final Color color;

  CustomizeCollectionColorAction(this.collection, this.color);
}

class CustomizeCollectionIconAction {
  final Collection collection;
  final IconData icon;

  CustomizeCollectionIconAction(this.collection, this.icon);
}

class RemoveCollectionAction {
  final Collection collection;

  RemoveCollectionAction(this.collection);
}

class RemoveTaskAction {
  final Collection collection;
  final Task task;

  RemoveTaskAction(this.collection, this.task);
}

class AddNewTaskToCollection {
  Collection collection;
  Task task;

  AddNewTaskToCollection({this.collection, this.task});
}

class GetCollectionsAction {}

class SetCompleteTaskAction {
  final Collection collection;
  final Task task;

  SetCompleteTaskAction(this.collection, this.task);
}

class UnSetCompleteTaskAction {
  final Collection collection;
  final Task task;

  UnSetCompleteTaskAction(this.collection, this.task);
}

class LoadedItemsAction {
  final List<Activity> activities;
  final List<Collection> collections;

  LoadedItemsAction(this.activities, this.collections);
}
