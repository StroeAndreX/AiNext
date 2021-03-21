import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeCollection/CustomizeCollectionColors.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CustomizeCollection/CustomizeCollectionIcon.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomizeCollectionPanel extends StatefulWidget {
  final Collection collection;
  final PanelController panelController;

  const CustomizeCollectionPanel(
      {Key key, this.collection, this.panelController})
      : super(key: key);

  @override
  _CustomizeCollectionPanelState createState() =>
      _CustomizeCollectionPanelState();
}

class _CustomizeCollectionPanelState extends State<CustomizeCollectionPanel> {
  Collection loadedCollection;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    loadedCollection = widget.collection;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(20),
            vertical: SizeConfig.getProportionateScreenHeight(20)),
        child: StoreConnector<AppState, CollectionsVM>(
            converter: (Store<AppState> store) => CollectionsVM.create(store),
            builder: (BuildContext context, CollectionsVM collectionsVM) {
              loadedCollection = store.state
                  .collections[Search.returnCollectionIndex(widget.collection)];

              _controller.text = loadedCollection.title;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.panelController.close();

                      if (_controller.text.trim() != "") {
                        store.dispatch(CustomizeCollectionNameAction(
                            loadedCollection, _controller.text));

                        setState(() {
                          _controller.clear();
                        });
                      }
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
                        store.dispatch(CustomizeCollectionNameAction(
                            loadedCollection, value));
                      }
                    },
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: loadedCollection.title, //"New Collection",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(color: Colors.black12),
                  SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),
                  CustomizeCollectionColors(collection: loadedCollection),
                  SizedBox(height: 16),
                  CustomizeCollectionIcon(collection: loadedCollection),
                ],
              );
            }),
      ),
    );
  }
}
