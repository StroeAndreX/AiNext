import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Label.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ColorCircleCollection.dart';
import 'package:AiOrganization/Widgets/ColorCircles.dart';
import 'package:AiOrganization/Widgets/LabelWidget.dart';
import 'package:AiOrganization/Widgets/SetLabelNameWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CustomizeCollectionColors extends StatefulWidget {
  final Collection collection;

  const CustomizeCollectionColors({Key key, this.collection}) : super(key: key);
  @override
  _CustomizeTaskLabelState createState() => _CustomizeTaskLabelState();
}

class _CustomizeTaskLabelState extends State<CustomizeCollectionColors> {
  /// Loaded collection
  Collection loadedCollection;

  /// [Create an widget for every label]
  List<Widget> labelsWidgets = [];
  List<Label> loadedLabels = [];

  @override
  void initState() {
    loadedCollection = widget.collection;
    // TODO: implement initState
    super.initState();
  }

  List<Widget> colorWidgets() {
    List<Widget> widgets = [];

    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];

    ColorsConfig.colorLabels.forEach((color) {
      widgets.add(GestureDetector(
        onTap: () {

          store.dispatch(
              CustomizeCollectionColorAction(loadedCollection, color));
        },
        child: ColorCircleCollection(
          color: color,
          collection: loadedCollection,
          isSelected: (loadedCollection.color == color) ? true : false,
        ),
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
              Container(
                height: SizeConfig.getProportionateScreenHeight(60),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 7,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    children: colorWidgets(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
