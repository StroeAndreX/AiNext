import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Screens/Collections/CollectionsHeader.dart';
import 'package:AiOrganization/Screens/Collections/CollectionsTabs.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageNoTasks.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/NewCollectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CollectionsScreen extends StatefulWidget {
  @override
  _CollectionsScreenState createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return StoreConnector<AppState, CollectionsVM>(
        converter: (Store<AppState> store) => CollectionsVM.create(store),
        builder: (BuildContext context, CollectionsVM collectionsVM) {
          return Stack(children: [
            CollectionsHeader(),
            Container(
              color: Colors.transparent,
              height: SizeConfig.screenHeight -
                  (60.0 + bottomPadding - (bottomPadding >= 15 ? 10 : 0)),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(20)),
              padding: EdgeInsets.only(
                  bottom: (SizeConfig.screenHeight >= 668)
                      ? SizeConfig.getProportionateScreenHeight(45)
                      : SizeConfig.getProportionateScreenHeight(35)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NewCollectionWidget(collectionName: "New Collection"),
              ),
            ),
            Column(
              children: [
                SizedBox(
                    height: (SizeConfig.screenHeight >= 668)
                        ? SizeConfig.getProportionateScreenHeight(130)
                        : SizeConfig.getProportionateScreenHeight(135)),
                Container(
                  height: SizeConfig.getProportionateScreenHeight(60),
                  decoration: BoxDecoration(
                      color: ColorsConfig.background,
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                    height: (SizeConfig.screenHeight >= 668)
                        ? SizeConfig.getProportionateScreenHeight(130)
                        : SizeConfig.getProportionateScreenHeight(135)),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: CollectionsTabs()),
              ],
            ),
          ]);
        });
  }
}
