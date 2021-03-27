import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskPanel.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/TaskWidget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePageTasks extends StatefulWidget {
  final String collectionName;
  final CollectionType collectionType;

  HomePageTasks(
      {this.collectionName, this.collectionType = CollectionType.CREATED});
  @override
  _HomePageTasksState createState() => _HomePageTasksState();
}

class _HomePageTasksState extends State<HomePageTasks> {
  // Declare variable that store the tasks of the currentDay and then display them
  List<Widget> taskWidgets = [];

  // Panel Control
  PanelController _panel = new PanelController();

  /// Loaded data needed for proper functionability of this page
  Collection loadedCollection;
  Task loadedTask;

  /// [Get all the tasks from the collection and then build them]
  void tasks(CollectionsVM collectionsVM) {
    taskWidgets = [];

    loadedCollection = store.state.collections
        .where((collection) => collection.title == widget.collectionName)
        .first;

    loadedCollection.tasks.forEach((task) {
      taskWidgets.add(TaskWidget(
        taskName: task.title,
        totalDuration: task.notes.toString(),
        collection: loadedCollection,
        task: task,
        panelController: _panel,
        function: openThePanel,
      ));
      taskWidgets.add(SizedBox(height: 10));
    });
  }

  /// [Open The panel]
  void openThePanel(Task task) async {
    panelSize = SizeConfig.getProportionateScreenHeight(590);
    if (_panel.isPanelOpen) {
      _panel.close();
      await Future.delayed(Duration(milliseconds: 150));
    }

    setState(() {
      loadedTask = task;
    });

    _panel.open();
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
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(
              left: SizeConfig.getProportionateScreenWidth(20),
              right: SizeConfig.getProportionateScreenWidth(20),
              top: SizeConfig.getProportionateScreenHeight(28),
            ),
            child: StoreConnector<AppState, CollectionsVM>(
                converter: (Store<AppState> store) =>
                    CollectionsVM.create(store),
                builder: (BuildContext context, CollectionsVM collectionsVM) {
                  loadedCollection = store.state.collections
                      .where((collection) =>
                          collection.title == widget.collectionName)
                      .first;

                  tasks(collectionsVM);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your tasks for today are…", style: messageStyle),
                      Container(
                        height: (SizeConfig.screenHeight >= 668)
                            ? SizeConfig.getProportionateScreenHeight(435)
                            : SizeConfig.getProportionateScreenHeight(398),
                        padding: EdgeInsets.only(bottom: 10),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView(
                            children: taskWidgets,
                          ),
                        ),
                      ),
                    ],
                  );
                })),
        Container(
            height: SizeConfig.getProportionateScreenHeight(600),
            child: SlidingUpPanel(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Color.fromRGBO(0, 0, 0, 0.10),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
                controller: _panel,
                minHeight: 0,
                maxHeight: (panelSize == null)
                    ? SizeConfig.getProportionateScreenHeight(590)
                    : panelSize,
                panel: (loadedTask != null)
                    ? CustomizeTaskPanel(
                        task: loadedTask,
                        changePanelSize: changePanelSize,
                        collection: loadedCollection,
                        panelController: _panel,
                      )
                    : SizedBox(),
                body: SizedBox())),
      ],
    );
  }
}
