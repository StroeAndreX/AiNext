import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class ActivitiesHeader extends StatefulWidget {
  @override
  _ActivitiesHeaderState createState() => _ActivitiesHeaderState();
}

class _ActivitiesHeaderState extends State<ActivitiesHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.getProportionateScreenHeight(155),
        child: Stack(
          children: [
            Image.asset("assets/pictures/Lignano.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(145),
                color: ColorsConfig.primary.withOpacity(.5)),
            Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getProportionateScreenHeight(80),
                  left: SizeConfig.getProportionateScreenWidth(20),
                  right: SizeConfig.getProportionateScreenWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Activities Tracker", style: titleStyle),
                  ],
                ))
          ],
        ));
  }
}
