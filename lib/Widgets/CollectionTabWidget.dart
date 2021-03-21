import 'dart:async';

import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksScreen.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/TextStylesConstants.dart';
import 'package:AiOrganization/Widgets/CustomAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionTabWidget extends StatefulWidget {
  final Collection collection;

  const CollectionTabWidget({Key key, this.collection}) : super(key: key);

  @override
  _CollectionTabWidgetState createState() => _CollectionTabWidgetState();
}

class _CollectionTabWidgetState extends State<CollectionTabWidget> {
  Future<bool> _warningMessage() async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: "",
      transitionDuration: Duration(milliseconds: 270),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOutBack.transform(animation.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, -curvedValue * 200, 0.0),
          child: Opacity(
            opacity: 1,
            child: child,
          ),
        );
      },
      pageBuilder: (BuildContext context, anim1, anim2) => CustomAlertDialog(
        title:
            "Do you really want to delete this task? The action is irreversible",
        actions: [
          CustomAlertDialogButton(
            text: "Yes",
            onTap: () => Navigator.of(context).pop(true),
            textColor: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          CustomAlertDialogButton(
            text: "No",
            textColor: ColorsConfig.background,
            backgroudColor: ColorsConfig.primary,
            onTap: () => Navigator.of(context).pop(false),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Dismissible(
      key: Key(widget.collection.id.toString()),
      onDismissed: (value) =>
          {store.dispatch(RemoveCollectionAction(this.widget.collection))},
      confirmDismiss: (DismissDirection direction) => _warningMessage(),
      background: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_forever_rounded, color: Colors.white))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  spreadRadius: 3)
            ]),
        child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            clipBehavior: Clip.none,
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.black.withOpacity(0.05),
              highlightColor: Colors.black.withOpacity(0.05),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionTasksScreen(
                            collection: widget.collection,
                            hasAutofocus: false,
                          )),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(18),
                    vertical: SizeConfig.getProportionateScreenHeight(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(widget.collection.iconData,
                            color: widget.collection.color,
                            size: SizeConfig.getProportionateScreenHeight(34)),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:
                                  SizeConfig.getProportionateScreenWidth(200),
                              child: Text(widget.collection.title,
                                  //"1000 Emails - Promote OpenDocu so everyone can have a simple access to the killer version of the application",
                                  style: taskStyle),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsConfig.primary,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
