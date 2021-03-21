import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Screens/CollectionTasks/CollectionTasksHeader.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Widgets/NewTaskWidget.dart';
import 'package:AiOrganization/Widgets/TaskWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionTasksBody extends StatefulWidget {
  final Collection collection;
  final bool hasAutofocus;

  const CollectionTasksBody(
      {Key key, this.collection, this.hasAutofocus = false})
      : super(key: key);

  @override
  _CollectionTasksBodyState createState() => _CollectionTasksBodyState();
}

class _CollectionTasksBodyState extends State<CollectionTasksBody> {
  // TextEditing for editing the name of the collection
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      _textEditingController.text = widget.collection.title;
    });

    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.getProportionateScreenWidth(20),
          right: SizeConfig.getProportionateScreenWidth(20)),
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            autofocus: widget.hasAutofocus,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                store.dispatch(
                    CustomizeCollectionNameAction(widget.collection, value));
              }
            },
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.collection.title, //"New Collection",
              hintStyle: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
