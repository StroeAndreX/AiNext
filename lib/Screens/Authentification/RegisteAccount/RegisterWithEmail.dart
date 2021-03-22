import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/AccountVM.dart';
import 'package:AiOrganization/Screens/Authentification/Login/LoginScreen.dart';
import 'package:AiOrganization/Screens/Authentification/RegisterSecurity/RegisterSecurityScreen.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ButtonWidget.dart';
import 'package:AiOrganization/Widgets/TextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

import 'package:email_validator/email_validator.dart';

class RegisterWithEmail extends StatefulWidget {
  @override
  _RegisterWithEmailState createState() => _RegisterWithEmailState();
}

class _RegisterWithEmailState extends State<RegisterWithEmail> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: (SizeConfig.blockSizeVertical > 7)
                ? SizeConfig.getProportionateScreenHeight(55)
                : SizeConfig.getProportionateScreenHeight(35)),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text:
                    "Sign up to bring your organization on Cloud and unluck important functions that will ",
                style: defaultStyle),
            TextSpan(text: "facilitate ", style: boldStyle),
            TextSpan(
                text: "your task and time management on Ai",
                style: defaultStyle),
            TextSpan(text: "Organization!", style: boldStyle),
          ]),
        ),
        SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
        TextFormFieldWidget(
          controller: _controller,
          hintText: "Email",
          backgroundColor: Color(0xFFF2F2F2),
          borderRadius: 5,
          autocorrent: false,
          enableSuggestions: false,
          inputBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Color(0xFFAFAFAF), style: BorderStyle.solid),
          ),
          validator: (value) {
            if (_controller.text.trim().length == 0) return "Can't be empty";

            return null;
          },
        ),
        SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
        StoreConnector<AppState, AccountVM>(
          converter: (Store<AppState> store) => AccountVM.create(store),
          builder: (BuildContext context, AccountVM accountVM) => ButtonWidget(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(20)),
            color: Colors.transparent,
            onPressed: () {
              if (EmailValidator.validate(_controller.text)) {
                Account newAccountState =
                    store.state.account.copyWith(email: _controller.text);

                accountVM.updateAccountState(newAccountState);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterSecurityScreen()),
                );
              }
            },
            child: Center(child: Text("Next", style: boldStyle)),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Have an account? Sign in", style: textButtonStyle))
      ],
    );
  }
}
