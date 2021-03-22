import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class LoginMessage extends StatefulWidget {
  @override
  _LoginMessageState createState() => _LoginMessageState();
}

class _LoginMessageState extends State<LoginMessage> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(text: "Lets sign you in. \n", style: titlePanelStyle),
      TextSpan(
          text: "Welcome back. \nYou’ve been missed!!",
          style: subtitlePanelStyle),
    ]));
  }
}
