import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/TaskActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskDate.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskDateButton.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeTask/CustomizeTaskLabel.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomizeTaskPanel extends StatefulWidget {
  final Task task;
  final Collection collection;
  final Function(double) changePanelSize;
  final Function() resetPanel;

  final PanelController panelController;

  const CustomizeTaskPanel(
      {Key key,
      this.task,
      this.changePanelSize,
      this.collection,
      this.resetPanel,
      this.panelController})
      : super(key: key);

  @override
  _CustomizeTaskPanelState createState() => _CustomizeTaskPanelState();
}

class _CustomizeTaskPanelState extends State<CustomizeTaskPanel> {
  /// Loaded task that is been displayed in the currentPanel
  Task loadedTask;
  Collection loadedCollection;

  /// Display the date selector
  bool isSelectDate = false;

  /// TextEditing
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    loadedTask = widget.task;
    loadedCollection = widget.collection;

    // TODO: implement initState
    super.initState();
  }

  void setSelectDate(bool select, double newPanelSize) {
    setState(() {
      isSelectDate = select;
      widget.changePanelSize(newPanelSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          loadedCollection = store.state
              .collections[Search.returnCollectionIndex(widget.collection)];
          loadedTask = loadedCollection
              .tasks[Search.returnTaskIndex(widget.collection, widget.task)];

          _controller.text = loadedTask.title;
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));

          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(20),
                vertical: SizeConfig.getProportionateScreenHeight(20)),
            child: SingleChildScrollView(
                child: (!isSelectDate)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.panelController.close();
                              widget.resetPanel();
                            },
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Text("Done", style: actionButtonStyle)),
                          ),
                          TextField(
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            autofocus: false,
                            controller: _controller,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                store.dispatch(CustomizeTaskNameAction(
                                    loadedCollection, loadedTask, value));
                              }
                            },
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: loadedTask.title, //"New Collection",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Divider(color: Colors.black12),
                          SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(8)),
                          Text("Label", style: messageStyle),
                          CustomizeTaskLabel(
                            task: loadedTask,
                            collection: loadedCollection,
                          ),
                          SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(12)),
                          Divider(color: Colors.black12),
                          CustomizeTaskDateButton(
                            task: loadedTask,
                            setSelectDate: setSelectDate,
                          ),
                          Divider(color: Colors.black12),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Notes", style: messageStyle),
                                Text(loadedTask.notes.length.toString(),
                                    style: taskStyle),
                              ],
                            ),
                            children: <Widget>[
                              Text('Big Bang'),
                              Text('Birth of the Sun'),
                              Text('Earth is Born'),
                            ],
                          ),
                        ],
                      )
                    : CustomizeTaskDate(
                        task: loadedTask,
                        returnToCustomize: setSelectDate,
                        collection: loadedCollection,
                      )),
          );
        });
  }
}

// mainAxisSpacing: 4.0,
//           childAspectRatio: 2.0,
//           crossAxisSpacing: 4.0,
//           crossAxisCount: 5,
