import 'Todo.dart';
import 'package:uuid/uuid.dart';

class TodoViewModel{


  List<Todo> _todoList = [
    Todo(uuid: Uuid().v4(), title: "Test", description: "desc", dateExpire: "datexpire", dateNotification: "datenotif", notification: "false", tag: "0"),
    Todo(uuid: Uuid().v4(), title: "Test2", description: "desc2", dateExpire: "datexpire", dateNotification: "datenotif", notification: "false", tag: "0")
  ];

  TodoViewModel();

  List<Todo> get todoList => _todoList;
}