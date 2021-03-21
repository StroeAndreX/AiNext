import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/CalendarLabels.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePageHeader extends StatefulWidget {
  String weekDay, month, day;

  HomePageHeader({this.weekDay, this.month, this.day});

  @override
  _HomePageHeaderState createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.getProportionateScreenHeight(265),
        child: Stack(
          children: [
            Image.asset("assets/pictures/Canada.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(265),
                color: ColorsConfig.primary.withOpacity(.5)),
            Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getProportionateScreenHeight(60),
                  left: SizeConfig.getProportionateScreenWidth(20),
                  right: SizeConfig.getProportionateScreenWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.menu_outlined, color: Colors.white),
                        Icon(Icons.lightbulb, color: Colors.white),
                      ],
                    ),
                    SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(60)),
                    Text("Goodmorning Andre,", style: titleStyle),
                    Text(
                        "Today is ${widget.weekDay}, ${widget.month} ${widget.day}",
                        style: subTitleStyle),
                  ],
                ))
          ],
        ));
  }
}
