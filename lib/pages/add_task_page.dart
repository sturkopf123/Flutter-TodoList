import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/bloc/todoProvider.dart';
import 'package:todo_v2/model/Todo.dart';
import 'package:todo_v2/widgets/datetimepicker.dart';
import 'package:uuid/uuid.dart';

class NewTodoPage extends StatefulWidget {

  final TodoBloc todoBloc;

  @override
  _NewTodoPageState createState() => _NewTodoPageState();

  NewTodoPage({Key key, this.todoBloc}):super(key: key);
}

class _NewTodoPageState extends State<NewTodoPage> {
  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = new TimeOfDay.now();
  bool checkboxnotification = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final _todoBloc = widget.todoBloc;
    return Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Neue Aufgabe"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          child: Text("Titel",
                            style: new TextStyle(
                              fontSize: 20.0,
                            ),)
                      ),
                      Container(
                        child: TextField(
                          controller: titleController,
                          maxLength: 20,
                          decoration: InputDecoration(
                              hintText: 'Titel eingeben...'
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          child: Text("Beschreibung",
                            style: new TextStyle(
                              fontSize: 20.0,
                            ),)
                      ),
                      Container(
                        child: TextField(
                          controller: descriptionController,
                          maxLength: 100,
                          decoration: InputDecoration(
                              hintText: 'Beschreibung eingeben...'
                          ),
                        ),
                      ),
                    ],
                  ),Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child:  new DateTimePicker(
                            labelText: 'Wann',
                            selectedDate: _toDate,
                            selectedTime: _toTime,
                            selectDateChanged: (DateTime date) {
                              setState(() {
                                _toDate = date;
                              });
                            },
                            selectTimeChanged: (TimeOfDay time) {
                              setState(() {
                                _toTime = time;
                              });
                            }
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Benachrichtigung",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Checkbox(
                              value: checkboxnotification,
                              tristate: false,
                              onChanged: (bool value){
                                setState(() {
                                  checkboxnotification = value;
                                });
                              }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Abbrechen"),
            ),
            FlatButton(
              onPressed: (){
                DateTime _datetime = new DateTime(_toDate.year, _toDate.month, _toDate.day, _toTime.hour, _toTime.minute);
                Todo todo = Todo(
                    uuid: Uuid().v1(),
                    title: titleController.text,
                    description: descriptionController.text,
                    dateExpire: _datetime.toString(),
                    dateNotification: _datetime.toString(),
                    notification: "false",
                    tag: "0");
                _todoBloc.addition.add(todo);
                Navigator.pop(context, true);
              },
              child: Text("Hinzufügen"),
            )
          ],
        ),
    );
  }

}

