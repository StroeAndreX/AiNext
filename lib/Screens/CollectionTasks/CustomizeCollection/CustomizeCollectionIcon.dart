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
import 'package:AiOrganization/Widgets/IconCircle.dart';
import 'package:AiOrganization/Widgets/LabelWidget.dart';
import 'package:AiOrganization/Widgets/SetLabelNameWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CustomizeCollectionIcon extends StatefulWidget {
  final Collection collection;

  const CustomizeCollectionIcon({Key key, this.collection}) : super(key: key);
  @override
  _CustomizeTaskLabelState createState() => _CustomizeTaskLabelState();
}

class _CustomizeTaskLabelState extends State<CustomizeCollectionIcon> {
  /// Loaded collection
  Collection loadedCollection;

  /// [Create an widget for every label]
  List<Widget> labelsWidgets = [];
  List<Label> loadedLabels = [];

  List<IconData> iconsList = [];

  @override
  void initState() {
    loadedCollection = widget.collection;
    buildIcons();
    // TODO: implement initState
    super.initState();
  }

  void buildIcons() {
    iconsList = [];
    iconsList.add(Icons.menu_open);
    iconsList.add(Icons.accessibility_new_outlined);
    iconsList.add(Icons.threed_rotation_rounded);
    iconsList.add(Icons.accessible_forward_outlined);
    iconsList.add(Icons.account_balance);
    iconsList.add(Icons.addchart);
    iconsList.add(Icons.alarm_add_outlined);
    iconsList.add(Icons.alarm_outlined);
    iconsList.add(Icons.all_inbox);
    iconsList.add(Icons.android);
    iconsList.add(Icons.api);
    iconsList.add(Icons.build);
    iconsList.add(Icons.calendar_view_day);
    iconsList.add(Icons.bug_report_outlined);
    iconsList.add(Icons.commute);
    iconsList.add(Icons.code);
    iconsList.add(Icons.compare_arrows_outlined);
    iconsList.add(Icons.contactless);
    iconsList.add(Icons.done);
    iconsList.add(Icons.done_all);
    iconsList.add(Icons.done_outline);
    iconsList.add(Icons.extension);
    iconsList.add(Icons.face);
    iconsList.add(Icons.gavel);
    iconsList.add(Icons.label);
    iconsList.add(Icons.list);
    iconsList.add(Icons.mediation);
    iconsList.add(Icons.https);
    iconsList.add(Icons.nightlife);
    iconsList.add(Icons.nights_stay);
    iconsList.add(Icons.nightlight_round);
    iconsList.add(Icons.flight_land);
    iconsList.add(Icons.flight_takeoff);
    iconsList.add(Icons.lightbulb);
    iconsList.add(Icons.attach_money_outlined);
    iconsList.add(Icons.money_off_csred_sharp);
  }

  List<Widget> iconWidgets() {
    buildIcons();
    List<Widget> widgets = [];

    loadedCollection = store
        .state.collections[Search.returnCollectionIndex(widget.collection)];

    iconsList.forEach((icon) {
      widgets.add(IconCircle(
        icon: icon,
        collection: loadedCollection,
        isSelected: (loadedCollection.iconData == icon) ? true : false,
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
                height: 400,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    children: iconWidgets(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
