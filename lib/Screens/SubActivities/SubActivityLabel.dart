import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Redux/Actions/ActivitiesActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubActivitiesLabel extends StatefulWidget {
  Activity activity;

  SubActivitiesLabel(this.activity);

  @override
  _SubActivitiesLabelState createState() => _SubActivitiesLabelState();
}

class _SubActivitiesLabelState extends State<SubActivitiesLabel> {
  int numLines = 0;
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.activity.title;

    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.getProportionateScreenWidth(20),
          right: SizeConfig.getProportionateScreenWidth(20)),
      child: Column(
        children: [
          TextField(
            textInputAction: TextInputAction.done,
            maxLines: 1,
            autofocus: true,
            controller: _controller,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                store.dispatch(CustomizeActivityAction(widget.activity,
                    newActivityName: value));
              }
            },
            onChanged: (String e) {
              setState(() {
                numLines = '\n'.allMatches(e).length + 1;
                print(numLines);
              });
            },
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.activity.title, //"New Collection",
              hintStyle: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
