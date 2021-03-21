import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Label.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ColorCircles.dart';
import 'package:AiOrganization/Widgets/LabelWidget.dart';
import 'package:AiOrganization/Widgets/SetLabelNameWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CustomizeTaskLabel extends StatefulWidget {
  final Task task;
  final Collection collection;

  const CustomizeTaskLabel({Key key, this.task, this.collection})
      : super(key: key);
  @override
  _CustomizeTaskLabelState createState() => _CustomizeTaskLabelState();
}

class _CustomizeTaskLabelState extends State<CustomizeTaskLabel> {
  /// Loaded task that is been displayed in the currentPanel
  Task loadedTask;
  Collection loadedCollection;

  /// [Create an widget for every label]
  List<Widget> labelsWidgets = [];
  List<Label> loadedLabels = [];

  @override
  void initState() {
    loadedTask = widget.task;
    loadedCollection = widget.collection;
    // TODO: implement initState
    super.initState();
  }

  List<Widget> colorWidgets() {
    List<Widget> widgets = [];

    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];

    loadedTask = loadedCollection
        .tasks[Search.returnTaskIndex(loadedCollection, widget.task)];
    ColorsConfig.colorLabels.forEach((color) {
      widgets.add(ColorCircle(
        color: color,
        collection: loadedCollection,
        task: loadedTask,
        isSelected: (loadedTask.colorLabel == color) ? true : false,
      ));
    });

    return widgets;
  }

  /// [For each assigned Task to a Label, register label]
  void buildLabelsList(Task task) {
    Label newLabel = Label(colorLabel: task.colorLabel, labelName: task.label);

    int index = loadedLabels.indexWhere((label) =>
        (label.colorLabel == task.colorLabel && label.labelName == task.label));
    if (index == -1) {
      loadedLabels.add(newLabel);
    }
  }

  void setLabelName(String text) {
    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];

    loadedTask = loadedCollection
        .tasks[Search.returnTaskIndex(loadedCollection, widget.task)];

    store.dispatch(CustomizeTaskLabelAction(
        loadedCollection, loadedTask, loadedTask.colorLabel, text));
  }

  /// [Find all the labels]
  void findLabels() {
    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];

    loadedTask = loadedCollection
        .tasks[Search.returnTaskIndex(loadedCollection, widget.task)];

    loadedLabels = [];

    loadedCollection.tasks.forEach((task) {
      if (task.colorLabel != Colors.transparent || task.label != null) {
        buildLabelsList(task);
      }
    });
  }

  void buildLabels() {
    /// Clear the Label list
    labelsWidgets = [];

    print(loadedLabels.toString());
    loadedLabels.forEach((label) {
      labelsWidgets.add(GestureDetector(
        onTap: () {
          store.dispatch(CustomizeTaskLabelAction(
              loadedCollection, loadedTask, label.colorLabel, label.labelName));
        },
        child: LabelWidget(
          colorLabel: label.colorLabel,
          labelName: (label.labelName != "" && label.labelName != null)
              ? label.labelName
              : "General",
        ),
      ));
      labelsWidgets.add(SizedBox(
        width: SizeConfig.getProportionateScreenWidth(10),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          findLabels();
          buildLabels();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
              Container(
                height: SizeConfig.getProportionateScreenHeight(70),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    // mainAxisSpacing: 4.0,
                    // childAspectRatio: 2.0,
                    // crossAxisSpacing: 4.0,
                    // crossAxisCount: 5,
                    crossAxisCount: 7,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    children: colorWidgets(),
                  ),
                ),
              ),
              SetLabelNameWidget(setLabelName: setLabelName),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),
              //Text("Exisiting Labels", style: taskStyle),
              (loadedLabels.isNotEmpty)
                  ? Container(
                      height: SizeConfig.getProportionateScreenHeight(40),
                      margin: EdgeInsets.symmetric(
                          vertical:
                              SizeConfig.getProportionateScreenHeight(10)),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: labelsWidgets,
                      ),
                    )
                  : SizedBox(),
            ],
          );
        });
  }
}
