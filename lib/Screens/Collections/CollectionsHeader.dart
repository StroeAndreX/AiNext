import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class CollectionsHeader extends StatefulWidget {
  @override
  _CollectionsHeaderState createState() => _CollectionsHeaderState();
}

class _CollectionsHeaderState extends State<CollectionsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.getProportionateScreenHeight(155),
        child: Stack(
          children: [
            Image.asset("assets/pictures/BigSur.png",
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
                    Text("Collections", style: titleStyle),
                  ],
                )),
          ],
        ));
  }
}
