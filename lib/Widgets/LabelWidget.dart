import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final Color colorLabel;
  final String labelName;

  const LabelWidget({Key key, this.colorLabel, this.labelName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(10),
            vertical: SizeConfig.getProportionateScreenHeight(10)),
        decoration: BoxDecoration(
          color: (colorLabel == Colors.transparent)
              ? ColorsConfig.primary
              : colorLabel,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(labelName ?? "", style: labelStyle));
  }
}
