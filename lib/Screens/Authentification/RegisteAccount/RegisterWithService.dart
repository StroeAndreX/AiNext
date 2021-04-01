import 'package:AiOrganization/Core/Firebase/AuthService.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/AccountVM.dart';
import 'package:AiOrganization/Screens/HomePage/HomePageScreen.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class RegisterWithService extends StatefulWidget {
  @override
  _RegisterWithServiceState createState() => _RegisterWithServiceState();
}

class _RegisterWithServiceState extends State<RegisterWithService> {
//// Import AuthService class
  AuthService _authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountVM>(
        converter: (Store<AppState> store) => AccountVM.create(store),
        builder: (BuildContext context, AccountVM accountVM) {
          return Column(
            children: [
              ButtonWidget(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(20),
                      vertical: SizeConfig.getProportionateScreenHeight(15)),
                  onPressed: () async {
                    await accountVM.signOut();

                    await accountVM
                        .signInWithGoogle()
                        .onError((error, stackTrace) => print(error));

                    if (store.state.account.uid != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => InitScreen()),
                          (route) => false);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset('assets/vector/search.svg')),
                      Text("Sign up with Google", style: taskStyle)
                    ],
                  )),
            ],
          );
        });
  }
}
