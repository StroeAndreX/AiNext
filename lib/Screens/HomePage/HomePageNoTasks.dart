import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/NewActivityWidget.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class HomePageNoTasks extends StatefulWidget {
  String collectionName;
  CollectionType collectionType;

  HomePageNoTasks({this.collectionName, this.collectionType});

  @override
  _HomePageNoTasksState createState() => _HomePageNoTasksState();
}

class _HomePageNoTasksState extends State<HomePageNoTasks> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(
          left: SizeConfig.getProportionateScreenWidth(20),
          right: SizeConfig.getProportionateScreenWidth(20),
          top: SizeConfig.getProportionateScreenHeight(48),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/vector/NoScheduledTasks.svg",
              height: SizeConfig.getProportionateScreenHeight(274),
            ),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            Text("You don’t have tasks scheduled for today",
                textAlign: TextAlign.center, style: messageStyle),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
          ],
        ));
  }
}
