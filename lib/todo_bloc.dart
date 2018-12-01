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
    addTodoController.stream.listen(onAddPerson);
    initialize();
  }

  void onAddPerson(Todo event){
    TodoDatabase db = TodoDatabase.get();
    db.insertTodo(event);
    _todos.add(event);
    todoListController.add(_todos);
    print("aaktl laenge ${_todos.length}");
  }

  void initialize(){
    todoListController.add(getTodos());
    //addTodoController.stream.listen(onAddPerson);
  }

  List<Todo> getTodos(){
    TodoDatabase db = TodoDatabase.get();
    db.getAllTodos().then((data){
      _todos = data;
    });
    return _todos;
  }
}