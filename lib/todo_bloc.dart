import 'package:todo_v2/TodoViewModel.dart';

import 'Todo.dart';
import 'dart:async';

class TodoBloc{

  List<Todo> _todos = [];

  final todoListController = StreamController<List<Todo>>();
  final addTodoController = StreamController<Todo>();

  Stream<List<Todo>> get todoList => todoListController.stream;
  Sink<Todo> get addTodo => addTodoController.sink;

  TodoBloc(){
    //addTodoController.stream.listen(onAddPerson);
    initialize();
  }

  void onAddPerson(Todo event){
    //TodoDatabase db = TodoDatabase.get();
    //db.insertTodo(event);
    _todos.add(event);
    print("dndjfdjff ${_todos.length}");
    todoListController.add(_todos);
  }

  void initialize(){
    todoListController.add(getTodos());
  }

  List<Todo> getTodos(){
    //TodoDatabase db = TodoDatabase.get();
    _todos = TodoViewModel().todoList;
    //db.getAllTodos().then((data){
    //  _todos = data;
    //});
    return _todos;
  }
}