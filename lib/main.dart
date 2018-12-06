import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/bloc/todoProvider.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/pages/add_task_page.dart';
import 'package:todo_v2/widgets/listView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoProvider(
      todoBloc: TodoBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
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

  TodoBloc todoBloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white30,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  TodoDatabase db = TodoDatabase.get();
                  db.dropTable();
                  todoBloc.dropTable();
                })
          ],
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.date_range),
            ),
            Tab(icon: Icon(Icons.event_available))
          ]),
          title: Text(widget.title),
        ),
        body: TabBarView(children: [
          StreamBuilder(
              stream: todoBloc.items,
              builder: (BuildContext context, snapData) {
                if (snapData.hasData && snapData.data.length != 0) {
                  return getListView(snapData.data, context, todoBloc);
                } else {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.done_all, size: 100.0,),
                        ],
                      )
                  );
                }
              }),
          StreamBuilder(
              stream: todoBloc.items,
              builder: (BuildContext context, snapData) {
                if (snapData.hasData && snapData.data.length != 0) {
                  return getListView(snapData.data, context, todoBloc);
                } else {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.done_all, size: 100.0,),
                        ],
                      ));
                }
              })
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewTodoPage(todoBloc: todoBloc,)));
            }),
      ),
    );
  }
}
