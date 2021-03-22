import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/AccountVM.dart';
import 'package:AiOrganization/Screens/Authentification/RegisteAccount/RegisterScreen.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ButtonWidget.dart';
import 'package:AiOrganization/Widgets/TextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountVM>(
      converter: (Store<AppState> store) => AccountVM.create(store),
      builder: (BuildContext context, AccountVM accountVM) => Column(
        children: [
          SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
          TextFormFieldWidget(
            controller: _emailController,
            hintText: "Email",
            backgroundColor: Color(0xFFF2F2F2),
            borderRadius: 5,
            autocorrent: false,
            enableSuggestions: false,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Color(0xFFAFAFAF), style: BorderStyle.solid),
            ),
            validator: (value) {
              if (_emailController.text.trim().length == 0)
                return "Can't be empty";

              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormFieldWidget(
            controller: _passwordController,
            obscureText: true,
            autocorrent: false,
            enableSuggestions: false,
            hintText: "Password",
            backgroundColor: Color(0xFFF2F2F2),
            borderRadius: 5,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Color(0xFFAFAFAF), style: BorderStyle.solid),
            ),
            validator: (value) {
              if (_passwordController.text.trim().length == 0)
                return "Can't be empty";

              return null;
            },
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(50)),
          ButtonWidget(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(20)),
            color: Colors.transparent,
            onPressed: () async {
              await accountVM.signInWithEmail(
                  _emailController.text, _passwordController.text);

              if (store.state.account.uid != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => InitScreen()),
                    (route) => false);
              }
            },
            child: Center(child: Text("Sign in", style: boldStyle)),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("Don’t have an account? Sign up",
                  style: textButtonStyle)),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
        ],
      ),
    );
  }
}
