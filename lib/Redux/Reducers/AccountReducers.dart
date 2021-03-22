import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/AccountActions.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Reducers/TaskReducers.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

Reducer<Account> accountReducers = combineReducers<Account>([
  TypedReducer<Account, UpdateAccountState>(updateAccountState),
]);

Account updateAccountState(Account state, dynamic action) {
  return action.account;
}
