import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/ActivityTabWidget.dart';
import 'package:AiOrganization/Widgets/CollectionTabWidget.dart';
import 'package:AiOrganization/Widgets/NewActivityWidget.dart';
import 'package:AiOrganization/Widgets/NewCollectionWidget.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ActivitiesTabs extends StatefulWidget {
  @override
  _ActivitiesTabsState createState() => _ActivitiesTabsState();
}

class _ActivitiesTabsState extends State<ActivitiesTabs> {
  /// Declare the list where all the Activity Tabs are going to be stored and displayed [TODO: Implement a limit of 20 activityTabs loaded xTime. LazyLoading]
  List<Widget> activityTabs = [];

  /// Build the activity Tabs and display them
  void buildActivitiesTabs(ActivitiesVM activitiesVM) {
    /// Clean the list
    activityTabs = [];

    /// For each activity the user created, build a tab[Widget]
    activitiesVM.activities.forEach((activity) {
      activityTabs.add(ActivityTabWidget(
        activity: activity,
      ));
      activityTabs.add(SizedBox(height: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(20)),
      child: StoreConnector<AppState, ActivitiesVM>(
          converter: (Store<AppState> store) => ActivitiesVM.create(store),
          builder: (BuildContext context, ActivitiesVM activitiesVM) {
            print("Rebuild?");
            buildActivitiesTabs(activitiesVM);
            return Column(
              children: [
                SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
                Container(
                  height: (SizeConfig.screenHeight >= 668)
                      ? SizeConfig.getProportionateScreenHeight(555)
                      : SizeConfig.getProportionateScreenHeight(538),
                  padding: EdgeInsets.only(bottom: 10),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: activityTabs,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
