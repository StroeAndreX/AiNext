import 'package:AiOrganization/Core/Firebase/CollectionsListeners/CollectionsDBListeners.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskPanel.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:AiOrganization/Widgets/TaskWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTaskTabs extends StatefulWidget {
  @override
  _CalendarTaskTabsState createState() => _CalendarTaskTabsState();
}

class _CalendarTaskTabsState extends State<CalendarTaskTabs> {
  Collection loadedCollection;
  CalendarController _calendarController;

  /// All the CalendarType collections
  Iterable<Collection> calendarTypeCollections = [];
  List<Collection> displayedCollections = [];
  Map<DateTime, List<dynamic>> collectionsForCalendar = {};

  // Tasks
  List<Task> tasks = [];
  List<Widget> taskWidgets = [];

  /// Build new collections or add new tasks to a custom date || or retrive the collection already existing
  String collectionTitle;
  DateTime selectedDate;

  /// [Load the task connected to the selectedDate collection]
  void getCalendarTypeCollections(CollectionsVM collectionsVM) {
    calendarTypeCollections = collectionsVM.collections.where(
        (collection) => collection.collectionType == CollectionType.CALENDAR);

    calendarTypeCollections.forEach((collection) {
      DateTime dayTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(collection.title));

      collectionsForCalendar[dayTime] = collection.tasks;
    });
  }

  /// [Load the collection based on the selectDate]
  void _selectDay(DateTime dateTime, List events, List holidays,
      {bool doSetState = true}) {
    /// Selected Date ---
    selectedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    /// Get the CollectionTitle
    setState(() {
      collectionTitle = selectedDate.millisecondsSinceEpoch.toString();
    });

    /// Set the collection name with the millisecondsSinceEpoch so I can easily access it in calendar
    if (store.state.account.isPremium)
      CollectionsDBListeners().listenToCollectionCalendarTasks(collectionTitle);
  }

  /// [Build all the tasks connected to the @selectedDate]
  void buildTasks() {
    /// Find the collection in the list based on the collectionTitle
    loadedCollection = calendarTypeCollections.firstWhere(
        (collection) => collection.title == collectionTitle,
        orElse: () => null);

    /// Fetch the Tasks---
    tasks = (loadedCollection != null) ? loadedCollection.tasks : [];

    taskWidgets = [];

    tasks.forEach((task) {
      taskWidgets.add(TaskWidget(
        taskName: task.title,
        totalDuration: task.notes.toString(),
        task: task,
        collection: loadedCollection,
        panelController: panelController,

        /// Variable declare in the [Customize Task Section]
        function: openThePanel,
      ));
      taskWidgets.add(SizedBox(height: 10));
    });
  }

  /// Build new collections or add new tasks to a custom date

  @override
  void initState() {
    _calendarController = CalendarController();

    getCalendarTypeCollections(CollectionsVM.create(store));
    _selectDay(DateTime.now(), [], []);

    // TODO: implement initState
    super.initState();
  }

  ////
  //// [Customize Task Section]
  ////

  /// Call the Task that you want to customize
  Task loadedTask;

  /// Call the Panel controller
  PanelController panelController = new PanelController();

  /// [Open The panel]
  void openThePanel(Task task) async {
    panelSize = SizeConfig.getProportionateScreenHeight(600);
    if (panelController.isPanelOpen) {
      panelController.close();
      await Future.delayed(Duration(milliseconds: 150));
    }

    setState(() {
      loadedTask = task;
    });

    panelController.open();
  }

  double panelSize;
  void changePanelSize(double newSize) {
    setState(() {
      panelSize = newSize;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          getCalendarTypeCollections(collectionsVM);
          buildTasks();

          return Stack(
            children: [
              Container(
                height: SizeConfig.screenHeight -
                    SizeConfig.getProportionateScreenHeight(145) -
                    SizeConfig.getProportionateScreenHeight(90.9),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TableCalendar(
                          onDaySelected: _selectDay,
                          events: collectionsForCalendar,
                          calendarStyle: CalendarStyle(
                              markersColor: ColorsConfig.primary,
                              weekdayStyle: calendarStyle),
                          initialCalendarFormat: CalendarFormat.week,
                          calendarController: _calendarController,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left:
                                    SizeConfig.getProportionateScreenWidth(20),
                                right:
                                    SizeConfig.getProportionateScreenWidth(20)),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView(
                                children: taskWidgets,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.getProportionateScreenWidth(20)),
                          padding: EdgeInsets.only(
                              bottom: (SizeConfig.screenHeight >= 668)
                                  ? SizeConfig.getProportionateScreenHeight(23)
                                  : SizeConfig.getProportionateScreenHeight(
                                      15)),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: NewTaskWidget(
                              collectionName: collectionTitle,
                              collectionType: CollectionType.CALENDAR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //// -------

              Container(
                height: SizeConfig.screenHeight -
                    SizeConfig.getProportionateScreenHeight(145) -
                    SizeConfig.getProportionateScreenHeight(90.9),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: SizeConfig.getProportionateScreenHeight(600),
                      child: SlidingUpPanel(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Color.fromRGBO(0, 0, 0, 0.10),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          controller: panelController,
                          minHeight: 0,
                          maxHeight: (panelSize == null)
                              ? SizeConfig.getProportionateScreenHeight(590)
                              : panelSize,
                          panel: (loadedTask != null)
                              ? CustomizeTaskPanel(
                                  task: loadedTask,
                                  changePanelSize: changePanelSize,
                                  collection: loadedCollection,
                                  panelController: panelController,
                                )
                              : SizedBox(),
                          body: SizedBox())),
                ),
              )
            ],
          );
        });
  }
}
