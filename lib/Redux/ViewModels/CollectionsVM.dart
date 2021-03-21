import 'package:AiOrganization/Models/Activity.dart';
import 'package:AiOrganization/Models/AppState.dart';
import 'package:AiOrganization/Models/Collection.dart';
import 'package:AiOrganization/Models/Task.dart';
import 'package:AiOrganization/Redux/Actions/CollectionActions.dart';
import 'package:redux/redux.dart';

class CollectionsVM {
  final List<Collection> collections;
  final Function(String, CollectionType, Task) newCollection;
  final Function(String) newEmptyCollection;
  final Function(Task, Collection) addNewTaskInCollection;
  final Function(Collection) removeCollection;
  final Function(Collection, Task) removeTask;
  final Function(Collection, Task) setCompleteTask;
  final Function(Collection, Task) unsetCompleteTask;

  CollectionsVM(
      {this.collections,
      this.newCollection,
      this.removeCollection,
      this.removeTask,
      this.newEmptyCollection,
      this.addNewTaskInCollection,
      this.setCompleteTask,
      this.unsetCompleteTask});

  factory CollectionsVM.create(Store<AppState> store) {
    _newCollection(
        String collectionName, CollectionType collectionType, Task task) {
      store.dispatch(NewCollectionAction(collectionName, collectionType, task));
    }

    _newEmptyCollection(String collectionName) {
      store.dispatch(NewEmptyCollectionAction(collectionName));
    }

    _addTaskInCollection(Task task, Collection collection) {
      store
          .dispatch(AddNewTaskToCollection(task: task, collection: collection));
    }

    _removeCollection(Collection collection) {
      store.dispatch(RemoveCollectionAction(collection));
    }

    _removeTask(Collection collection, Task task) {
      store.dispatch(RemoveTaskAction(collection, task));
    }

    _setCompleteTask(Collection collection, Task task) {
      store.dispatch(SetCompleteTaskAction(collection, task));
    }

    _unsetCompleteTask(Collection collection, Task task) {
      store.dispatch(UnSetCompleteTaskAction(collection, task));
    }

    return CollectionsVM(
        collections: store.state.collections,
        newCollection: _newCollection,
        newEmptyCollection: _newEmptyCollection,
        addNewTaskInCollection: _addTaskInCollection,
        removeCollection: _removeCollection,
        setCompleteTask: _setCompleteTask,
        unsetCompleteTask: _unsetCompleteTask,
        removeTask: _removeTask);
  }
}
