import 'package:flutter/material.dart';
import 'package:todo_v2/TodoBlocProvider.dart';
//import 'package:todo_v2/TodoViewModel.dart';
import 'package:todo_v2/add_task_page.dart';
//import 'package:todo_v2/database.dart';
import 'package:todo_v2/listview.dart';
import 'package:todo_v2/todo_bloc.dart';
//import 'package:uuid/uuid.dart';
//import 'Todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoBlocProvider(
      todoBloc: TodoBloc(),
      child:  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );



  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final todoBloc = TodoBlocProvider.of(context);
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
            stream: todoBloc.todoList,
            builder: (BuildContext context, snapData) {
              if (snapData.hasData) {
                print("hasdata ${snapData.data.length}");
                return CustomListView(todos: snapData.data);
              } else {
                return Container(
                  child: Text("nodata"),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewTodoPage()));
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.event),
                onPressed: (){},
              ),
              IconButton(
                  icon: Icon(Icons.event_available),
                  onPressed: (){})
            ],
          ),
        )
    );
  }
}