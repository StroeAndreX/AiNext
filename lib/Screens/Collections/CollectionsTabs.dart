import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/CollectionTabWidget.dart';
import 'package:AiOrganization/Widgets/NewCollectionWidget.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CollectionsTabs extends StatefulWidget {
  @override
  _CollectionsTabsState createState() => _CollectionsTabsState();
}

class _CollectionsTabsState extends State<CollectionsTabs> {
  /// List of CollectionTab Widgets that load all the collection and display them
  List<Widget> collectionTabs = [];

  /// [Build collectionTabs]
  void buildCollectionTabs(CollectionsVM collectionsVM) {
    collectionTabs = [];

    collectionsVM.collections.forEach((collection) {
      collectionTabs.add(CollectionTabWidget(
        collection: collection,
      ));

      collectionTabs.add(SizedBox(height: 12));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: StoreConnector<AppState, CollectionsVM>(
          converter: (Store<AppState> store) => CollectionsVM.create(store),
          builder: (BuildContext context, CollectionsVM collectionsVM) {
            buildCollectionTabs(collectionsVM);
            return Column(
              children: [
                SizedBox(height: SizeConfig.getProportionateScreenHeight(35)),
                TextField(
                  decoration:
                      InputDecoration(hintText: "Search for collection"),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(15)),
                Container(
                  height: (SizeConfig.screenHeight >= 668)
                      ? SizeConfig.getProportionateScreenHeight(480)
                      : SizeConfig.getProportionateScreenHeight(460),
                  padding: EdgeInsets.only(bottom: 10),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: collectionTabs,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
