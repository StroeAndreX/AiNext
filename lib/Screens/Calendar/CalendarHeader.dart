import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatefulWidget {
  @override
  _CalendarHeaderState createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.getProportionateScreenHeight(145),
        child: Stack(
          children: [
            Image.asset("assets/pictures/Barcellona.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(145),
                color: ColorsConfig.primary.withOpacity(.5)),
            Padding(
                padding: EdgeInsets.only(
                  top: (SizeConfig.screenHeight >= 668)
                      ? SizeConfig.getProportionateScreenHeight(90)
                      : SizeConfig.getProportionateScreenHeight(80),
                  left: SizeConfig.getProportionateScreenWidth(20),
                  right: SizeConfig.getProportionateScreenWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Calendar", style: titleStyle),
                  ],
                ))
          ],
        ));
  }
}
