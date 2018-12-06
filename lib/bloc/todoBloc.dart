import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/model/Todo.dart';

class TodoBloc {
  final List<Todo> _items = List<Todo>();

  TodoBloc() {
    _additionStreamController.stream.listen(_handleAddition);
    _removalStreamController.stream.listen(_handleRemoval);
    initialize();
  }

  _handleAddition(Todo item) async{
    TodoDatabase db = TodoDatabase.get();
    List<Todo> _temp = await db.getAllTodos();
    _temp.add(item);
    _itemsSubject.add(_temp);
    db.insertTodo(item);
  }

  _handleRemoval(Todo item) async{
    TodoDatabase db = TodoDatabase.get();
    List<Todo> _temp = await db.getAllTodos();
    _temp.remove(item);
    _itemsSubject.add(_temp);
    db.deleteTodo(item);
  }

  void dropTable(){
    List<Todo> _temp = List<Todo>();
    _itemsSubject.add(_temp);
  }

  void dispose() {
    _additionStreamController.close();
    _removalStreamController.close();
  }

  Stream<List<Todo>> get items => _itemsSubject.stream;
  final _itemsSubject = BehaviorSubject<List<Todo>>();

  Sink<Todo> get addition => _additionStreamController.sink;
  final _additionStreamController = StreamController<Todo>();

  Sink<Todo> get removal => _removalStreamController.sink;
  final _removalStreamController = StreamController<Todo>();

  void initialize() async {
    _itemsSubject.add(await getTodos());
  }

  Future<List<Todo>> getTodos() {
    TodoDatabase db = TodoDatabase.get();
    return db.getAllTodos();
  }
}
