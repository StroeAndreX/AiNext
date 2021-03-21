import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';

class AppState {
  final List<Activity> activities;
  final List<Collection> collections;

  const AppState({this.activities, this.collections});

  AppState.initialState()
      : activities = List.unmodifiable(<Activity>[]),
        collections = List.unmodifiable(<Collection>[]);

  // AppState.fromJson(Map json)
  //     : activities = (json['activities'] as List)
  //           .map((i) => Activity.fromMap(i))
  //           .toList(),
  //       collections = (json['collections'] as List)
  //           .map((i) => Collection.fromMap(i))
  //           .toList();

  Map toJson() => {'activities': activities, 'collections': collections};
}
