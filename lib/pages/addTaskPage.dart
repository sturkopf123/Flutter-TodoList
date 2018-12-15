import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/model/Todo.dart';
import 'package:todo_v2/widgets/datetimepicker.dart';
import 'package:uuid/uuid.dart';

class NewTodoPage extends StatefulWidget {
  final TodoBloc todoBloc;

  @override
  _NewTodoPageState createState() => _NewTodoPageState();

  NewTodoPage({Key key, this.todoBloc}) : super(key: key);
}

class _NewTodoPageState extends State<NewTodoPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  TodoDatabase db = TodoDatabase.get();

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future _scheduleNotification(Todo task) async {
    print("task ${task.uuid} eingereiht");
    var scheduledNotificationDateTime = DateTime.parse(task.dateNotification);
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'to_do_list_flutter',
        'ToDo List Channel',
        'Notificationchannel for ToDo List App',
        icon: 'done_all',
        sound: '',
        color: Colors.blue,
        style: AndroidNotificationStyle.BigText,
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(sound: "");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        task.uuid.hashCode,
        task.title,
        task.description,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: task.uuid);
  }

  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = new TimeOfDay.now();
  DateTime _toDateNotifcation = new DateTime.now();
  TimeOfDay _toTimeNotifcation = new TimeOfDay(
      hour: TimeOfDay
          .now()
          .hour, minute: TimeOfDay
      .now()
      .minute + 15);
  bool _notification = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _notify = false;

  void _updateTime() {
    _toDate = new DateTime.now();
    _toTime = new TimeOfDay.now();
    DateTime _temp = DateTime.now().add(new Duration(minutes: 15));
    _toDateNotifcation = _temp;
    _toTimeNotifcation = new TimeOfDay(hour: _temp.hour, minute: _temp.minute);
  }

  Widget _showNotification(bool notify) {
    if (notify) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: new DateTimePicker(
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
                  }),
            )
          ]);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _todoBloc = widget.todoBloc;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Neues Todo"),
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
                        child: TextField(
                          controller: titleController,
                          maxLength: 20,
                          decoration:
                          InputDecoration(
                              labelText: "Titel",
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15.0))
                              ),
                              hintText: 'Titel eingeben.')
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
                        child: TextField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          maxLength: 150,
                          decoration: InputDecoration(
                              labelText: "Beschreibung",
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15.0))
                              ),
                              hintText: 'Beschreibung eingeben.'),
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
                        child: new DateTimePicker(
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
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Benachrichtigung",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Checkbox(
                                value: _notification,
                                tristate: false,
                                onChanged: (bool value) {
                                  setState(() {
                                    _updateTime();
                                    _notification = value;
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
            onPressed: () {
              String _datetime = new DateTime(_toDate.year, _toDate.month,
                  _toDate.day, _toTime.hour, _toTime.minute)
                  .toString();
              String _datetimeNotification = new DateTime(
                  _toDateNotifcation.year,
                  _toDateNotifcation.month,
                  _toDateNotifcation.day,
                  _toTimeNotifcation.hour,
                  _toTimeNotifcation.minute)
                  .toString();
              if (titleController.text != "") {
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
                if (_notify) {
                  _scheduleNotification(todo);
                }
                Navigator.pop(context, true);
              } else {
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
