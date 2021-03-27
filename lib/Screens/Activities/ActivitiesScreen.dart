import 'package:AiOrganization/Core/Firebase/ActivitiesListeners/ActivitiesDBListeners.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/ActivitiesVM.dart';
import 'package:AiOrganization/Screens/Activities/ActivitiesHeader.dart';
import 'package:AiOrganization/Screens/Activities/ActivitiesTabs.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/NewActivityWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    if (store.state.account.isPremium)
      ActivitiesDBListeners().listenToActivities();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(children: [
      ActivitiesHeader(),
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
          child: NewActivityWidget(),
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
          SizedBox(height: SizeConfig.getProportionateScreenHeight(130)),
          StoreConnector<AppState, ActivitiesVM>(
            converter: (Store<AppState> store) => ActivitiesVM.create(store),
            builder: (BuildContext context, ActivitiesVM activitiesVM) {
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: ActivitiesTabs());
            },
          ),
        ],
      ),
    ]);
  }
}
