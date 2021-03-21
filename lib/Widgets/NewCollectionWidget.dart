import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksScreen.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewCollectionWidget extends StatefulWidget {
  String collectionName;

  NewCollectionWidget({this.collectionName});
  @override
  _NewCollectionWidgetState createState() => _NewCollectionWidgetState();
}

class _NewCollectionWidgetState extends State<NewCollectionWidget> {
  String collectionName = "";

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectionsVM>(
      converter: (Store<AppState> store) => CollectionsVM.create(store),
      builder: (BuildContext context, CollectionsVM collectionsVM) =>
          GestureDetector(
              onTap: () {
                collectionName = "New Collection " +
                    collectionsVM.collections.length.toString();

                collectionsVM.newEmptyCollection(collectionName);

                print("Collections: " +
                    store.state.collections.length.toString());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionTasksScreen(
                            collection: store.state.collections.last,
                            hasAutofocus: true,
                          )),
                );
              },
              child: Container(
                height: SizeConfig.blockSizeVertical < 7 ? 54 : 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorsConfig.textFieldBorder)),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: TextField(
                      onSubmitted: (value) {},
                      decoration: InputDecoration(
                        enabled: false,
                        hintText: "New Collection",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.black54),
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            fontSize: 14.0, color: ColorsConfig.primaryText),
                        icon: Icon(
                          Icons.add,
                          color: ColorsConfig.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
