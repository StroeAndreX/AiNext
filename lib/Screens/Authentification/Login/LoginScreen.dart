import 'package:AiOrganization/Screens/Authentification/Login/LoginMessage.dart';
import 'package:AiOrganization/Screens/Authentification/Login/LoginForm.dart';
import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterWithEmail.dart';
import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterWithService.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    ColorsConfig().init(context);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: ColorsConfig.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          ),
        ),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Ai',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                          fontSize:
                              SizeConfig.getProportionateScreenWidth(24)))),
              TextSpan(
                  text: 'Organization',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      textStyle: TextStyle(
                          fontSize:
                              SizeConfig.getProportionateScreenWidth(24)))),
            ],
          ),
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              height: (SizeConfig.blockSizeVertical > 7)
                  ? SizeConfig.getProportionateScreenHeight(55)
                  : SizeConfig.getProportionateScreenHeight(35)),
          LoginMessage(),
          LoginForm(),
          SizedBox(
              height: (SizeConfig.blockSizeVertical > 7)
                  ? SizeConfig.getProportionateScreenHeight(190)
                  : SizeConfig.getProportionateScreenHeight(120)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider(color: Colors.black)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(12)),
                child: Text("OR", style: messageStyle),
              ),
              Expanded(child: Divider(color: Colors.black)),
            ],
          ),
          RegisterWithService()
        ]),
      ),
    );
  }
}
