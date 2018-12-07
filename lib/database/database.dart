import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_v2/model/Todo.dart';

class TodoDatabase {
  static final TodoDatabase _todoDatabase = new TodoDatabase._internal();


  final String tableName = "Todos";

  Database db;

  bool didInit = false;

  static TodoDatabase get() {
    return _todoDatabase;
  }

  TodoDatabase._internal();

  Future<Database> _getDb() async{
    if(!didInit) await _init();
    return db;
  }

  Future init() async {
    print("init db");
    return await _init();
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todos.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE $tableName ("
                  "${Todo.dbUUID} STRING PRIMARY KEY,"
                  "${Todo.dbTitle} TEXT,"
                  "${Todo.dbDescription} TEXT,"
                  "${Todo.dbDateExpire} TEXT,"
                  "${Todo.dbDateNotification} TEXT,"
                  "${Todo.dbNotification} TEXT,"
                  "${Todo.dbTag} TEXT"
                  ")");
        });
    didInit = true;
  }

  Future<List<Todo>> getDoneTodos() async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Todo.dbTag} = 1');
    List<Todo> todos = [];
    for(Map<String, dynamic> item in result){
      todos.add(new Todo.fromMap(item));
    }
    return todos;
  }

  Future<List<Todo>> getPendingTodos() async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Todo.dbTag} = 0');
    List<Todo> todos = [];
    for(Map<String, dynamic> item in result){
      todos.add(new Todo.fromMap(item));
    }
    return todos;
  }

  Future<Todo> getIdOfTodo(Todo todo) async {
    var db = await _getDb();
    List<String> args = List<String>();
    args.add(todo.uuid);
    var result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Todo.dbUUID} = ?', args);
    Todo id;
    for (Map<String, dynamic> item in result) {
      todo = Todo.fromMap(item);
    }
    return id;
  }

  Future<Todo> getTodo(String uuid) async {
    var db = await _getDb();
    var result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Todo.dbUUID} = $uuid');
    Todo todos;
    for (Map<String, dynamic> item in result) {
      todos = new Todo.fromMap(item);
    }
    return todos;
  }

  Future<int> insertTodo(Todo todo) async {
    var db = await _getDb();
    return await db.insert(tableName, todo.toMap());
  }

  Future updatetodo(Todo todo) async{
    var db = await _getDb();
    return await db.update(tableName, todo.toMap(), where: "${Todo.dbUUID} = ?", whereArgs: [todo.uuid]);
  }

  Future deleteTodo(Todo todo) async{
    var db = await _getDb();
    return await db.delete(tableName, where: "${Todo.dbUUID} = ?", whereArgs: [todo.uuid]);
  }

  Future dropTable() async{
    var db = await _getDb();
    db.delete(tableName);
    init();
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }

}
