import 'package:todo_v2/TodoViewModel.dart';
import 'package:todo_v2/database.dart';

import 'Todo.dart';
import 'dart:async';

class TodoBloc{
  List<Todo> _todos = [];

  final todoListController = StreamController<List<Todo>>();
  final addTodoController = StreamController<Todo>();

  Stream<List<Todo>> get todoList => todoListController.stream;
  Sink<Todo> get addTodo => addTodoController.sink;

  TodoBloc(){
    initialize();
    addTodoController.stream.listen(onAddPerson);
  }

  void onAddPerson(Todo event){
    TodoDatabase db = TodoDatabase.get();
    db.insertTodo(event);
    _todos.add(event);
    todoListController.add(_todos);
    print("aaktl laenge ${_todos.length}");
  }

  void initialize() async{
    todoListController.add(await getTodos());
  }

  Future<List<Todo>> getTodos(){
    TodoDatabase db = TodoDatabase.get();
    return db.getAllTodos();
  }
}