import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

class RegisterSecurityMessage extends StatefulWidget {
  @override
  _RegisterSecurityMessageState createState() =>
      _RegisterSecurityMessageState();
}

class _RegisterSecurityMessageState extends State<RegisterSecurityMessage> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: "Security is really important.. lock your account with",
              style: defaultStyle),
          TextSpan(text: " strong password!\n\n ", style: boldStyle),
          TextSpan(
              text:
                  "The stronger the password, the more protected your account will be!",
              style: defaultStyle),
        ]));
  }
}
