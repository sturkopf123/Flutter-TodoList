import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/model/Todo.dart';
import 'package:todo_v2/widgets/smallWidgets.dart';

class CustomListView extends StatefulWidget {
  final List<Todo> items;
  final TodoBloc todoBloc;

  @override
  _CustomListViewState createState() => _CustomListViewState();

  CustomListView({this.items, this.todoBloc});
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                  elevation: 6.0,
                  child: ExpansionTile(
                    initiallyExpanded: (index == 0) ? true : false,
                    title: Text(widget.items[index].title),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getDate(widget.items[index].dateExpire),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getNotificationDate(
                                  widget.items[index].dateNotification,
                                  widget.items[index].notification)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getDescription(
                                  widget.items[index].description, context),
                            ],
                          ),
                          getButtonRow(widget.items[index], widget.todoBloc)
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
