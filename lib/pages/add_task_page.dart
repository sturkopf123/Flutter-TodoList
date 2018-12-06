import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/database/database.dart';
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
  //TODO check if min+15 which would end in new day actually changed the da to the following
  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = new TimeOfDay.now();
  DateTime _toDateNotifcation = new DateTime.now();
  TimeOfDay _toTimeNotifcation = new TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 15);
  bool checkboxnotification = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _notify = false;

  void _updateTime(){
    _toDate = new DateTime.now();
    _toTime = new TimeOfDay.now();
    _toDateNotifcation = new DateTime.now();
    _toTimeNotifcation = new TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 15);
  }

  Widget _showNotification(bool notify){
    if(notify){
      return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
        Container(
        child:  new DateTimePicker(
            labelText: 'Wann',
            selectedDate: _toDateNotifcation,
            selectedTime: _toTimeNotifcation,
            selectDateChanged: (DateTime date) {
              setState(() {
                _toDateNotifcation = date;
              });
            },
            selectTimeChanged: (TimeOfDay time) {
              setState(() {
                _toTimeNotifcation = time;
              });
            }
        ),
      )]);
    }else{
      return Container();
    }
  }

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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Column(
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
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            maxLength: 150,
                            decoration: InputDecoration(
                                hintText: 'Beschreibung eingeben...'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Column(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Row(
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
                                      _updateTime();
                                      checkboxnotification = value;
                                      _notify = value;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        _showNotification(_notify),
                      ],
                    ),
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
                String _datetime = new DateTime(_toDate.year, _toDate.month, _toDate.day, _toTime.hour, _toTime.minute).toString();
                String _datetimeNotification = new DateTime(_toDateNotifcation.year, _toDateNotifcation.month, _toDateNotifcation.day, _toTimeNotifcation.hour, _toTimeNotifcation.minute).toString();
                if(titleController.text != ""){
                  Todo todo = Todo(
                      uuid: Uuid().v1(),
                      title: titleController.text,
                      description: descriptionController.text,
                      dateExpire: _datetime,
                      dateNotification: _datetimeNotification,
                      notification: _notify.toString(),
                      tag: "0");
                  TodoDatabase db = TodoDatabase.get();
                  db.insertTodo(todo);
                  _todoBloc.initialize();
                  Navigator.pop(context, true);
                }else{
                 _showDialog(context);
                }
              },
              child: Text("Hinzufügen"),
            )
          ],
        ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Titel fehlt"),
          content: new Text("Bitte geben sie einen Titel ein."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Schließen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

