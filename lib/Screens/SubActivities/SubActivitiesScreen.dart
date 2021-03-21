import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksBody.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksHeader.dart';
import 'package:AiOrganization/Screens/SubActivities/SubActivitiesHeader.dart';
import 'package:AiOrganization/Screens/SubActivities/SubActivityLabel.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ActivityTabWidget.dart';
import 'package:AiOrganization/Widgets/NewActivityWidget.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:AiOrganization/Widgets/SubActivityTabWidget.dart';
import 'package:AiOrganization/Widgets/TaskWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

class SubActivitiesScreen extends StatefulWidget {
  Activity activity;

  SubActivitiesScreen({this.activity});

  @override
  _SubActivitiesScreenState createState() => _SubActivitiesScreenState();
}

class _SubActivitiesScreenState extends State<SubActivitiesScreen> {
  /// Declare the list where all the Activity Tabs are going to be stored and displayed [TODO: Implement a limit of 20 activityTabs loaded xTime. LazyLoading]s
  List<Widget> subActvitiesWidgets = [];

  /// Loaded activity that is been displayed in the currentScreen
  Activity loadedActivity;

  @override
  void initState() {
    loadedActivity =
        store.state.activities[Search.returnActivityIndex(widget.activity)];

    // TODO: implement initState
    super.initState();
  }

  void tasks() {
    /// Clean the list
    subActvitiesWidgets = [];

    /// For each subActivity the user created, build a tab[Widget]
    widget.activity.subActivities.forEach((subActivity) {
      subActvitiesWidgets.add(SubActivityTabWidget(
        subActivity: subActivity,
        activity: loadedActivity,
      ));
      subActvitiesWidgets.add(SizedBox(height: 10));
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorsConfig().init(context);
    SizeConfig().init(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: Column(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: StoreConnector<AppState, ActivitiesVM>(
                converter: (Store<AppState> store) =>
                    ActivitiesVM.create(store),
                builder: (BuildContext context, ActivitiesVM activitiesVM) =>
                    SubActivitiesHeader(
                  activity: widget.activity,
                ),
              ),
            ),
            SubActivitiesLabel(widget.activity),
            StoreConnector<AppState, ActivitiesVM>(
              converter: (Store<AppState> store) => ActivitiesVM.create(store),
              builder: (BuildContext context, ActivitiesVM activitiesVM) {
                tasks();
                return Column(
                  children: [
                    Container(
                      height: SizeConfig.getProportionateScreenHeight(545),
                      margin: EdgeInsets.only(
                          left: SizeConfig.getProportionateScreenWidth(20),
                          right: SizeConfig.getProportionateScreenWidth(20)),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: subActvitiesWidgets,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.getProportionateScreenWidth(20),
                    right: SizeConfig.getProportionateScreenWidth(20),
                    bottom: SizeConfig.getProportionateScreenHeight(40)),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: NewActivityWidget(
                      isActivity: false,
                      activity: widget.activity,
                    )),
              ),
            )
          ]),
        ));
  }
}
