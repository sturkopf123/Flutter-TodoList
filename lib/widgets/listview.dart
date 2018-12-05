import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_v2/model/Todo.dart';

class CustomListView extends StatefulWidget {
  final List<Todo> todos;

  CustomListView({Key key, @required this.todos}):super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();

}

class _CustomListViewState extends State<CustomListView> {

  @override
  Widget build(BuildContext context){
    print("data length ${widget.todos.length}");
    return new Material(
      child: new Container(
          color: Colors.blueGrey,
          padding: EdgeInsets.all(10.0),
          child: getListView(widget.todos),
    )
    );
  }

  ListView getListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos == null ? 0 : todos.length,
      itemBuilder: (BuildContext context, int pos) {
        return getRow(pos, todos);
      },
    );
  }

  Widget getRow(int i, List<Todo> todos) {

    var newline = todos[i].description.length == 0 ? "" : "\n\n";
    //String _date =
    //new DateFormat.yMMMd().add_Hm().format(DateTime.parse(todos[i].dateExpire));

    return new Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: ListTile(
                key: Key(todos[i].uuid),
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${todos[i].title}",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                subtitle: Text("\n${todos[i].description}$newline${todos[i].dateExpire}"),
                onTap: () {
                  print(todos[i].uuid);
                },
              ),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){},
                  ),
                  IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


