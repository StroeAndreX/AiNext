import 'package:AiOrganization/Core/Search.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:AiOrganization/Redux/Store.dart';
import 'package:AiOrganization/Redux/ViewModels/CollectionsVM.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewTaskWidget extends StatefulWidget {
  String collectionName;
  CollectionType collectionType;

  Collection collection;

  NewTaskWidget({this.collectionName, this.collectionType, this.collection});
  @override
  _NewTaskWidgetState createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  /// The controller of the textField
  TextEditingController _controller = new TextEditingController();

  /// Call the parameters of the widget to maintain updated and alter
  String collectionName;
  Collection collection;
  CollectionType collectionType;

  // Name of the new Task
  String taskName;
  Task newTask;

  /// Set the declared variables
  @override
  void initState() {
    collectionName = widget.collectionName;
    collectionType = widget.collectionType;

    collection = widget.collection;

    // TODO: implement initState
    super.initState();
  }

  /// [Make the control for the ColletionType Calendar]
  /// Control if a collection with this name already exist or not
  /// If the collection doesn't exist the task will be setted as [@id: 1] and create the collection
  /// Otherwise just add the task in the collection and retrive the new [@id] by using the [Search] class
  void calendarCollectionInsertion() {
    if (checkCollectionExistance() == -1) {
      newTask = Task(id: 1, title: taskName, notes: []);

      store.dispatch(
          NewCollectionAction(collectionName, collectionType, newTask));
    } else {
      collection = store.state.collections.firstWhere(
          (collection) => collection.title == widget.collectionName);

      /// Declare the new id assigned to the next created task
      int newID = Search.returnNewTaskID(collection);

      /// Create task
      collection = store.state.collections[checkCollectionExistance()];
      newTask = Task(id: newID, title: taskName, notes: []);

      store.dispatch(
          AddNewTaskToCollection(collection: collection, task: newTask));
    }
  }

  /// [Simple insertion of a task into a CollectionType CREATED]
  void createdCollectionInsertion() {
    /// Declare the new id assigned to the next created task
    int newID = Search.returnNewTaskID(collection);

    // Create the new task
    newTask = Task(
        id: Search.returnNewTaskID(collection),
        title: (taskName.trim() != "" && taskName.trim() != null)
            ? taskName
            : "New Task",
        notes: []);

    // Call the Reducer that store the new task
    store.dispatch(
        AddNewTaskToCollection(collection: collection, task: newTask));
  }

  void addNewTask() {
    /// Use @par - CollectionName
    /// Use @par - CollectionType

    /// Always updated
    collectionName = widget.collectionName;
    collectionType = widget.collectionType;

    if (collectionType == CollectionType.CALENDAR)
      calendarCollectionInsertion();
    else
      createdCollectionInsertion();
  }

  /// [It return -1 if the collection doesn't exist.. else it return the exact index]
  int checkCollectionExistance() {
    return store.state.collections
        .indexWhere((collection) => collection.title == collectionName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.blockSizeVertical < 7 ? 54 : 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsConfig.textFieldBorder)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: StoreConnector<AppState, CollectionsVM>(
            converter: (Store<AppState> store) => CollectionsVM.create(store),
            builder: (BuildContext context, CollectionsVM collectionsVM) =>
                Center(
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  taskName = value;

                  addNewTask();

                  setState(() {
                    value = "";
                    _controller.clear();
                  });
                },
                decoration: InputDecoration(
                  hintText: "New Task",
                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.black54),
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      fontSize: 14.0, color: ColorsConfig.primaryText),
                  icon: Icon(
                    Icons.add,
                    color: ColorsConfig.primary,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
