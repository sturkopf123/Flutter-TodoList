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


  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async{
    if(!didInit) await _init();
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todos.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
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

  /// Get a Todo by its id, if there is not entry for that ID, returns null.
  Future<Todo> getTodo(String id) async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Todo.dbUUID} = "$id"');
    if(result.length == 0)return null;
    return new Todo.fromMap(result[0]);
  }

  Future<int> getKeyIDFromUUID(String id) async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT id_key FROM $tableName WHERE ${Todo.dbUUID} = "$id"');
    if(result.length == 0) return null;
    return result[0]['${Todo.dbUUID}'];
  }

  /// Get all todos with ids, will return a list with all the todos found
  Future<List<Todo>> getTodos(List<String> ids) async{
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Todo.dbUUID} IN ($idsString)');
    List<Todo> todos = [];
    for(Map<String, dynamic> item in result) {
      todos.add(new Todo.fromMap(item));
    }
    return todos;
  }

  Future<List<Todo>> getAllTodos() async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Todo.dbTag} = 0');
    List<Todo> todos = [];
    for(Map<String, dynamic> item in result){
      todos.add(new Todo.fromMap(item));
    }
    return todos;
  }

  Future<List<String>> getIDs() async{
    var db = await _getDb();
    var results = await db.rawQuery('SELECT * from $tableName');
    List<String> ids = [];
    for(Map<String, dynamic> item in results){
      ids.add(item['${Todo.dbUUID}'].toString());
    }
    return ids;
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
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }

}
