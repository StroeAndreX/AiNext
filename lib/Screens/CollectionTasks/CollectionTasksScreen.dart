import 'package:AiOrganization/Core/Firebase/CollectionsDB.dart';
import 'package:AiOrganization/Core/Firebase/CollectionsListeners/CollectionsDBListeners.dart';
import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Label.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksBody.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksHeader.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeCollection/CustomizeColletionPanel.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskPanel.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/LabelWidget.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:AiOrganization/Widgets/TaskWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CollectionTasksScreen extends StatefulWidget {
  bool hasAutofocus;
  Collection collection;

  CollectionTasksScreen({this.collection, this.hasAutofocus});

  @override
  _CollectionTasksScreenState createState() => _CollectionTasksScreenState();
}

class _CollectionTasksScreenState extends State<CollectionTasksScreen> {
  Collection collection;
  List<Widget> taskWidgets = [];
  List<Widget> labelsWidgets = [];
  List<Label> labels = [];

  // Panel Control
  PanelController _panel = new PanelController();

  @override
  void initState() {
    collection = widget.collection;

    if (store.state.account.isPremium)
      CollectionsDBListeners().listenToCollectionTasks(widget.collection);

    // TODO: implement initState
    super.initState();
  }

  void tasks(Collection collection) {
    taskWidgets = [];
    labels = [];

    collection.tasks.forEach((task) {
      if (task.colorLabel != Colors.transparent || task.label != null) {
        buildLabelsList(task);
      }

      taskWidgets.add(TaskWidget(
        taskName: task.title,
        totalDuration: task.notes.toString(),
        task: task,
        collection: collection,
        panelController: _panel,
        function: openThePanel,
      ));
      taskWidgets.add(SizedBox(height: 10));
    });

    buildLabels();
  }

  /// [For each assigned Task to a Label, register label]
  void buildLabelsList(Task task) {
    Label newLabel = Label(colorLabel: task.colorLabel, labelName: task.label);

    int index = labels.indexWhere((label) =>
        (label.colorLabel == task.colorLabel && label.labelName == task.label));
    if (index == -1) {
      labels.add(newLabel);
    }
  }

  /// [Create an widget for every label]
  void buildLabels() {
    /// Clear the Label list
    labelsWidgets = [];

    labels.forEach((label) {
      labelsWidgets.add(LabelWidget(
        colorLabel: label.colorLabel,
        labelName: (label.labelName != "" && label.labelName != null)
            ? label.labelName
            : "General",
      ));
      labelsWidgets.add(SizedBox(
        width: SizeConfig.getProportionateScreenWidth(10),
      ));
    });
  }

  ///
  /// [Open The panel]
  ///
  Task loadTask;
  void openThePanel(Task task) async {
    panelSize = SizeConfig.getProportionateScreenHeight(600);
    if (_panel.isPanelOpen) {
      _panel.close();
      await Future.delayed(Duration(milliseconds: 150));
    }

    setState(() {
      loadTask = task;
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

  void resetPanel() {
    setState(() {
      loadTask = null;
    });
  }

  ///
  /// [Firestore implementation management] --> TODO: Ultra Optimization using In-App checking and avoiding useless writings or readings || Phase 6 of AiOrganziation [The Ultra optimization]
  ///

  List<Task> recentlyAdded = [];
  List<Task> recentlyModified = [];

  // @Not Used for now --> Optimization fase TODO: Optimize
  void insertRecentlyAdded(Task task) {
    recentlyAdded.add(task);
  }

  // @Not Used for now --> Optimization fase TODO: Optimize
  void insertRecentlyModified(Task task) {
    bool _isInRecentlyAdded = false;

    recentlyAdded.forEach((taskInList) {
      if (taskInList.id == task.id) _isInRecentlyAdded = true;
    });

    if (!_isInRecentlyAdded) recentlyAdded.add(task);
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
          body: SlidingUpPanel(
            boxShadow: [
              BoxShadow(
                blurRadius: 8.0,
                color: Color.fromRGBO(0, 0, 0, 0.10),
              )
            ],
            borderRadius: BorderRadius.circular(20),
            controller: _panel,
            minHeight: 0,
            onPanelClosed: () {
              setState(() {
                loadTask = null;
              });
            },
            maxHeight: (panelSize == null)
                ? SizeConfig.getProportionateScreenHeight(600)
                : panelSize,
            panel: (loadTask != null)
                ? CustomizeTaskPanel(
                    task: loadTask,
                    changePanelSize: changePanelSize,
                    collection: collection,
                    panelController: _panel,
                    resetPanel: resetPanel,
                  )
                : CustomizeCollectionPanel(
                    collection: collection,
                    panelController: _panel,
                  ),
            body: GestureDetector(
              onTap: () {
                if (_panel.isPanelOpen) {
                  _panel.close();
                  resetPanel();
                }
              },
              child: Column(children: [
                CollectionTasksHeader(
                    panelController: _panel, collection: collection),
                //CollectionTasksBody(),
                StoreConnector<AppState, CollectionsVM>(
                  converter: (Store<AppState> store) =>
                      CollectionsVM.create(store),
                  builder: (BuildContext context, CollectionsVM collectionsVM) {
                    collection = collectionsVM.collections
                        .where((element) => element.id == collection.id)
                        .first;

                    tasks(collection);

                    return Column(
                      children: [
                        (labels.isNotEmpty)
                            ? Container(
                                height:
                                    SizeConfig.getProportionateScreenHeight(40),
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.getProportionateScreenWidth(
                                            20),
                                    vertical:
                                        SizeConfig.getProportionateScreenHeight(
                                            10)),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: labelsWidgets,
                                ),
                              )
                            : SizedBox(),
                        CollectionTasksBody(
                          collection: collection,
                          hasAutofocus: widget.hasAutofocus,
                        ),
                        Container(
                          height: SizeConfig.getProportionateScreenHeight(545),
                          margin: EdgeInsets.only(
                              left: SizeConfig.getProportionateScreenWidth(20),
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
                        child: StoreConnector<AppState, CollectionsVM>(
                            converter: (Store<AppState> store) =>
                                CollectionsVM.create(store),
                            builder: (BuildContext context,
                                CollectionsVM collectionsVM) {
                              Collection loadedCollection =
                                  collectionsVM.collections[
                                      Search.returnCollectionIndex(collection)];

                              return NewTaskWidget(
                                collection: loadedCollection,
                                collectionName:
                                    collection.title, //"CollectionName",
                              );
                            })),
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
