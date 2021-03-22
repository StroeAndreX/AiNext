import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/Collection.dart';

class AppState {
  final Account account;

  final List<Activity> activities;
  final List<Collection> collections;

  const AppState({this.account, this.activities, this.collections});

  AppState.initialState()
      : activities = List.unmodifiable(<Activity>[]),
        collections = List.unmodifiable(<Collection>[]),
        account = Account();

  // AppState.fromJson(Map json)
  //     : activities = (json['activities'] as List)
  //           .map((i) => Activity.fromMap(i))
  //           .toList(),
  //       collections = (json['collections'] as List)
  //           .map((i) => Collection.fromMap(i))
  //           .toList();

  Map toJson() => {
        'activities': activities,
        'collections': collections,
        'account': account
      };
}
