import 'package:AiOrganization/Core/Firebase/CollectionsDB.dart';
import 'package:AiOrganization/Core/Firebase/CollectionsListeners/CollectionsDBListeners.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageHeader.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageNoTasks.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageTasks.dart';
import 'package:AiOrganization/Styles/CalendarLabels.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  /// [Declare variables]
  /// Build the current Date
  String weekDay, month;
  DateTime now = DateTime.now();

  // Import labels
  List<String> monthLabels;
  List<String> weekDaysLabels;

  /// Set the collection as CollectionType calendar
  CollectionType collectionType = CollectionType.CALENDAR;

  /// TodayTasks
  String collectionName;
  List<Task> todayTasks = [];

  /// [Functions and buildings]
  /// Import the "TodayCollection" - Find if the collection exist.
  int _todayCollection() {
    return store.state.collections
        .indexWhere((collection) => collection.title == collectionName);
  }

  void initData() {
    collectionType = CollectionType.CALENDAR;
    monthLabels = CalendarLabelsConfig.fullMonthLabels(context);
    weekDaysLabels = CalendarLabelsConfig.fullWeekLabels(context);
    now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    weekDay = weekDaysLabels[now.weekday - 1];
    month = monthLabels[now.month - 1];

    /// Set the collection name with the millisecondsSinceEpoch so I can easily access it in calendar
    collectionName = now.millisecondsSinceEpoch
        .toString(); //now.day.toString() + month.toString();

    if (store.state.account.isPremium)
      CollectionsDBListeners().listenToCollectionCalendarTasks(collectionName);

    /// Retrive tasks if the collection is now empty
    if (_todayCollection() != -1) {
      todayTasks = store.state.collections[_todayCollection()].tasks;
    }
  }

  void refreshTask(CollectionsVM collectionsVM) {
    if (_todayCollection() != -1) {
      todayTasks = collectionsVM.collections[_todayCollection()].tasks;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /// [BUILDER]
  @override
  Widget build(BuildContext context) {
    /// Load The homepage data
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    ///  Load The homepage data
    initData();

    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          refreshTask(collectionsVM);
          return Stack(children: [
            Container(
              color: Colors.transparent,
              height: SizeConfig.screenHeight -
                  (60.0 + bottomPadding - (bottomPadding >= 15 ? 10 : 0)),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(20)),
              padding: EdgeInsets.only(
                  bottom: (SizeConfig.screenHeight >= 668)
                      ? SizeConfig.getProportionateScreenHeight(45)
                      : SizeConfig.getProportionateScreenHeight(35)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NewTaskWidget(
                  collectionName: collectionName,
                  collectionType: collectionType,
                ),
              ),
            ),
            HomePageHeader(
              weekDay: weekDay,
              month: month,
              day: now.day.toString(),
            ),
            Column(
              children: [
                SizedBox(
                    height: (SizeConfig.screenHeight >= 668)
                        ? SizeConfig.getProportionateScreenHeight(225)
                        : SizeConfig.getProportionateScreenHeight(243)),
                Container(
                  height: SizeConfig.getProportionateScreenHeight(60),
                  decoration: BoxDecoration(
                      color: ColorsConfig.background,
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                    height: (SizeConfig.screenHeight >= 668)
                        ? SizeConfig.getProportionateScreenHeight(225)
                        : SizeConfig.getProportionateScreenHeight(243)),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: (_todayCollection() == -1 || todayTasks.length == 0)
                      ? HomePageNoTasks(
                          collectionName: collectionName,
                          collectionType: collectionType)
                      : HomePageTasks(
                          collectionName: collectionName,
                          collectionType: collectionType,
                        ),
                ),
              ],
            ),
          ]);
        });
  }
}
