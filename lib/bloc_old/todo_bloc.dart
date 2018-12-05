import 'dart:async';

import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/model/Todo.dart';

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

  void dispose() {
    todoListController.close();
    addTodoController.close();
  }

  void onAddPerson(Todo event){
    TodoDatabase db = TodoDatabase.get();
    db.insertTodo(event);
    _todos.add(event);
    todoListController.add(_todos);
  }

  void initialize() async{
    todoListController.add(await getTodos());
  }

  Future<List<Todo>> getTodos(){
    TodoDatabase db = TodoDatabase.get();
    return db.getAllTodos();
  }
}