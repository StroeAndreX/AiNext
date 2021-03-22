import 'package:AiOrganization/Models/Account.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Screens/Authentification/Login/LoginScreen.dart';
import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterScreen.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/CalendarLabels.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePageHeader extends StatefulWidget {
  String weekDay, month, day;

  HomePageHeader({this.weekDay, this.month, this.day});

  @override
  _HomePageHeaderState createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  Account myAccount = new Account();

  @override
  Widget build(BuildContext context) {
    myAccount = store.state.account;
    return Container(
        height: SizeConfig.getProportionateScreenHeight(265),
        child: Stack(
          children: [
            Image.asset("assets/pictures/Canada.png",
                width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
            Container(
                height: SizeConfig.getProportionateScreenHeight(265),
                color: ColorsConfig.primary.withOpacity(.5)),
            Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getProportionateScreenHeight(50),
                  left: SizeConfig.getProportionateScreenWidth(20),
                  right: SizeConfig.getProportionateScreenWidth(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            )
                          },
                          child: Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      (myAccount.photoUrl != null &&
                                              myAccount.photoUrl.trim() != "")
                                          ? NetworkImage(myAccount.photoUrl)
                                          : null,
                                ),
                                SizedBox(width: 8),
                                Text(
                                    (myAccount.uid == null)
                                        ? "Login to your account"
                                        : "Hello, ${myAccount.displayName}",
                                    style: labelStyle)
                              ],
                            ),
                          ),
                        ),
                        //Icon(Icons.menu_outlined, color: Colors.white),
                        Icon(Icons.lightbulb, color: Colors.white),
                      ],
                    ),
                    SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(60)),
                    Text("Goodmorning,", style: titleStyle),
                    Text(
                        "Today is ${widget.weekDay}, ${widget.month} ${widget.day}",
                        style: subTitleStyle),
                  ],
                ))
          ],
        ));
  }
}
