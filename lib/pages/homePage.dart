import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/pages/addTaskPage.dart';
import 'package:todo_v2/pages/settingsPage.dart';
import 'package:todo_v2/widgets/listView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.themeBloc}) : super(key: key);

  final String title;
  final ThemeBloc themeBloc;

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
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        themeBloc: widget.themeBloc,
                        todoBloc: todoBloc,
                      )));
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
              stream: todoBloc.itemsPending,
              builder: (BuildContext context, snapData) {
                if (snapData.hasData && snapData.data.length != 0) {
                  return CustomListView(
                    items: snapData.data,
                    todoBloc: todoBloc,
                  );
                } else {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done_all,
                            size: 100.0,
                          ),
                        ],
                      ));
                }
              }),
          StreamBuilder(
              stream: todoBloc.itemsDone,
              builder: (BuildContext context, snapData) {
                if (snapData.hasData && snapData.data.length != 0) {
                  return CustomListView(
                    items: snapData.data,
                    todoBloc: todoBloc,
                  );
                } else {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done_all,
                            size: 100.0,
                          ),
                        ],
                      ));
                }
              })
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewTodoPage(
                        todoBloc: todoBloc,
                      )));
            }),
      ),
    );
  }
}
