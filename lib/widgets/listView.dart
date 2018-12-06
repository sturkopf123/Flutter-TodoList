import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/model/Todo.dart';
import 'package:intl/intl.dart';

Widget getListView(List<Todo> items, BuildContext context, TodoBloc todoBloc) {
  return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Card(
              elevation: 6.0,
              child: ExpansionTile(
                title: Text(items[index].title),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          getDate(items[index].dateExpire),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          getNotificationDate(items[index].dateNotification, items[index].notification)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          getDescription(items[index].description, context),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                print("pressed");
                                todoBloc.removal.add(items[index]);
                              }),
                          IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                print("pressed");
                              })
                        ],
                      )
                    ],
                  )
                ],
              )),
        );
      });
}

Widget getDescription(String description, BuildContext context) {
  double _width = MediaQuery.of(context).size.width*0.9;
  if (description != "") {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Container(
          //width: _width,
            child: Text(description, softWrap: true,)
        )
    );
  } else {
    return Container();
  }
}

Widget getDate(String dateExpire) {
  String _date =
      new DateFormat.yMMMd().add_Hm().format(DateTime.parse(dateExpire));
  return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            opacity: 0.6,
              child: Icon(Icons.event, size: 16.0,)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(_date,),
          ),
        ],
      ));
}

Widget getNotificationDate(String dateNotification, String notification) {
  String _date =
      new DateFormat.yMMMd().add_Hm().format(DateTime.parse(dateNotification));
  if (notification == "true") {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Row(
          children: <Widget>[
            Opacity(
                opacity: 0.6,
                child: Icon(Icons.notifications_active, size: 16.0,)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(_date,),
            ),
          ],
        ));
  } else {
    return Container();
  }
}
