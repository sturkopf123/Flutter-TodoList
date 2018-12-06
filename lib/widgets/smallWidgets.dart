import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/model/Todo.dart';
import 'package:intl/intl.dart';

Widget getButtonRow(Todo todo, TodoBloc todoBloc) {
  if (todo.tag == "0") {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              todoBloc.removalPending.add(todo);
            }),
        IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              todoBloc.changePending.add(todo);
            })
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              todoBloc.removalDone.add(todo);
            }),
      ],
    );
  }
}

Widget getDescription(String description, BuildContext context) {
  double _width = MediaQuery.of(context).size.width*0.8;
  if (description != "") {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Container(
            width: _width,
            child: Text(
          description,
          softWrap: true,
        )));
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
              child: Icon(
                Icons.event,
                size: 16.0,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              _date,
            ),
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
                child: Icon(
                  Icons.notifications_active,
                  size: 16.0,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                _date,
              ),
            ),
          ],
        ));
  } else {
    return Container();
  }
}
