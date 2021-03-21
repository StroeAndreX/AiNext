import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CollectionTasksHeader extends StatefulWidget {
  final PanelController panelController;

  const CollectionTasksHeader({Key key, this.panelController})
      : super(key: key);

  @override
  _CollectionTasksHeaderState createState() => _CollectionTasksHeaderState();
}

class _CollectionTasksHeaderState extends State<CollectionTasksHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.getProportionateScreenHeight(100),
        child: Stack(
          children: [
            Image.asset("assets/pictures/BigSur.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(145),
                color: ColorsConfig.primary.withOpacity(.5)),
            Container(
              height: SizeConfig.getProportionateScreenHeight(100),
              margin: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(10),
                  right: SizeConfig.getProportionateScreenWidth(30),
                  top: SizeConfig.getProportionateScreenHeight(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        Text("Collections", style: leadingStyle)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.panelController.open(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
