import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterWithEmail.dart';
import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterWithService.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RegisterWithEmail(),
              // SizedBox(
              //     height: (SizeConfig.blockSizeVertical > 7)
              //         ? SizeConfig.getProportionateScreenHeight(30)
              //         : SizeConfig.getProportionateScreenHeight(20)),
              SizedBox(
                  height: (SizeConfig.blockSizeVertical > 7)
                      ? SizeConfig.getProportionateScreenHeight(250)
                      : SizeConfig.getProportionateScreenHeight(220)),
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
              // SizedBox(
              //     height: (SizeConfig.blockSizeVertical > 7)
              //         ? SizeConfig.getProportionateScreenHeight(30)
              //         : SizeConfig.getProportionateScreenHeight(20)),

              RegisterWithService()
            ],
          ),
        ));
  }
}
