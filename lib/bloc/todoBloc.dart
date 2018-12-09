import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_v2/algorithms/quicksort.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/model/Todo.dart';

class TodoBloc {
  TodoBloc() {
    _additionPendingStreamController.stream.listen(_handleAdditionPending);
    _removalPendingStreamController.stream.listen(_handleRemovalPending);
    _changePendingStreamController.stream.listen(_handleChangePending);

    _additionDoneStreamController.stream.listen(_handleAdditionDone);
    _removalDoneStreamController.stream.listen(_handleRemovalDone);
    _changeDoneStreamController.stream.listen(_handleChangeDone);
    initialize();
  }

  _handleChangePending(Todo todo) async {
    TodoDatabase db = TodoDatabase.get();
    Todo _temp = todo;
    _temp.tag = "1";
    _temp.notification = "false";
    await db.updatetodo(todo);
    initialize();
  }

  _handleChangeDone(Todo todo) async {
    TodoDatabase db = TodoDatabase.get();
    Todo _temp = todo;
    _temp.notification = "false";
    _temp.tag = "0";
    await db.updatetodo(todo);
    initialize();
  }

  _handleAdditionPending(Todo item) async {
    TodoDatabase db = TodoDatabase.get();
    List<Todo> _temp = await db.getDoneTodos();
    _temp.add(item);
    _temp = quickSort(_temp);
    _itemsPendingSubject.add(quickSort(_temp));
    db.insertTodo(item);
  }

  _handleRemovalPending(Todo item) async {
    TodoDatabase db = TodoDatabase.get();
    await db.deleteTodo(item);
    List<Todo> _temp = await db.getPendingTodos();
    _temp = quickSort(_temp);
    _itemsPendingSubject.add(_temp);
  }

  _handleAdditionDone(Todo item) async {
    TodoDatabase db = TodoDatabase.get();
    List<Todo> _temp = await db.getDoneTodos();
    _temp.add(item);
    _temp = quickSort(_temp);
    _itemsDoneSubject.add(quickSort(_temp));
    db.insertTodo(item);
  }

  _handleRemovalDone(Todo item) async {
    TodoDatabase db = TodoDatabase.get();
    await db.deleteTodo(item);
    List<Todo> _temp = await db.getDoneTodos();
    _temp = quickSort(_temp);
    _itemsDoneSubject.add(_temp);
  }

  void dropTable() {
    List<Todo> _temp = List<Todo>();
    _itemsDoneSubject.add(_temp);
    _itemsPendingSubject.add(_temp);
  }

  void dispose() {
    _additionDoneStreamController.close();
    _removalDoneStreamController.close();
    _additionPendingStreamController.close();
    _removalPendingStreamController.close();
    _changePendingStreamController.close();
    _changeDoneStreamController.close();
  }

  //Bloc things for done todos
  Stream<List<Todo>> get itemsDone => _itemsDoneSubject.stream;
  final _itemsDoneSubject = BehaviorSubject<List<Todo>>();

  Sink<Todo> get additionDone => _additionDoneStreamController.sink;
  final _additionDoneStreamController = StreamController<Todo>();

  Sink<Todo> get removalDone => _removalDoneStreamController.sink;
  final _removalDoneStreamController = StreamController<Todo>();

  Sink<Todo> get changeDone => _changeDoneStreamController.sink;
  final _changeDoneStreamController = StreamController<Todo>();

  //Bloc things for pending todos
  Stream<List<Todo>> get itemsPending => _itemsPendingSubject.stream;
  final _itemsPendingSubject = BehaviorSubject<List<Todo>>();

  Sink<Todo> get additionPending => _additionPendingStreamController.sink;
  final _additionPendingStreamController = StreamController<Todo>();

  Sink<Todo> get changePending => _changePendingStreamController.sink;
  final _changePendingStreamController = StreamController<Todo>();

  Sink<Todo> get removalPending => _removalPendingStreamController.sink;
  final _removalPendingStreamController = StreamController<Todo>();

  void initialize() async {
    List<Todo> _pen = await getPendingTodos();
    print("pending: ${_pen.length}");
    List<Todo> _don = await getDoneTodos();
    print("done: ${_don.length}");
    _itemsDoneSubject.add(quickSort(_don));
    _itemsPendingSubject.add(quickSort(_pen));
  }

  Future<List<Todo>> getPendingTodos() {
    TodoDatabase db = TodoDatabase.get();
    return db.getPendingTodos();
  }

  Future<List<Todo>> getDoneTodos() {
    TodoDatabase db = TodoDatabase.get();
    return db.getDoneTodos();
  }
}
