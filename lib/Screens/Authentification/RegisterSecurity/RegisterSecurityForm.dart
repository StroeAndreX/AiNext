import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/AccountVM.dart';
import 'package:AiOrganization/Screens/InitScreen.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/ButtonWidget.dart';
import 'package:AiOrganization/Widgets/TextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RegisterSecurityForm extends StatefulWidget {
  @override
  _RegisterSecurityFormState createState() => _RegisterSecurityFormState();
}

class _RegisterSecurityFormState extends State<RegisterSecurityForm> {
  // Security password textEditingController
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountVM>(
      converter: (Store<AppState> store) => AccountVM.create(store),
      builder: (BuildContext context, AccountVM accountVM) => Column(
        children: [
          SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Insert Password", style: calendarStyle)),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(6)),
          TextFormFieldWidget(
            controller: _passwordController,
            hintText: "Password",
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
              if (_passwordController.text.trim().length == 0)
                return "Can't be empty";

              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormFieldWidget(
            controller: _confirmPasswordController,
            obscureText: true,
            hintText: "Repeat Password",
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
              if (_confirmPasswordController.text.trim().length == 0)
                return "Can't be empty";

              return null;
            },
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Additional Info", style: calendarStyle)),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(6)),
          TextFormFieldWidget(
            controller: _nameController,
            autocorrent: false,
            enableSuggestions: false,
            obscureText: false,
            hintText: "Name",
            backgroundColor: Color(0xFFF2F2F2),
            borderRadius: 5,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Color(0xFFAFAFAF), style: BorderStyle.solid),
            ),
            validator: (value) {
              if (_confirmPasswordController.text.trim().length == 0)
                return "Can't be empty";

              return null;
            },
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(60)),
          ButtonWidget(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionateScreenWidth(20)),
            color: Colors.transparent,
            onPressed: () async {
              await accountVM.createNewAccount(
                  accountVM.account.email,
                  _confirmPasswordController.text.trim(),
                  _nameController.text.trim());

              if (store.state.account.uid != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => InitScreen()),
                    (route) => false);
              }
            },
            child: Center(child: Text("Finish Registration", style: boldStyle)),
          ),
        ],
      ),
    );
  }
}
