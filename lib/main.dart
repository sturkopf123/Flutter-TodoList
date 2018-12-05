import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/bloc/todoProvider.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/pages/add_task_page.dart';
import 'package:todo_v2/widgets/listview.dart';
//import 'package:todo_v2/TodoViewModel.dart';
//import 'package:todo_v2/database.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoProvider(
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

  TodoBloc todoBloc = TodoBloc();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete), onPressed: () {
              TodoDatabase db = TodoDatabase.get();
              db.dropTable();
            })
          ],
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.event),),
            Tab(icon: Icon(Icons.event_available))
          ]),
          title: Text(widget.title),
        ),
        body: TabBarView(
            children: [
              StreamBuilder(
                  stream: todoBloc.items,
                  builder: (BuildContext context, snapData) {
                    if (snapData.hasData) {
                      return CustomListView(todos: snapData.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              StreamBuilder(
                  stream: todoBloc.items,
                  builder: (BuildContext context, snapData) {
                    if (snapData.hasData) {
                      return CustomListView(todos: snapData.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewTodoPage()));
            }),
      ),
    );
  }

}