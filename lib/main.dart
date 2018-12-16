import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/bloc/todoProvider.dart';
import 'package:todo_v2/pages/homePage.dart';
import 'package:todo_v2/themes/custom_themes.dart';


/// TODO reschedule notification on undo
/// TODO localization


Future main() async {
  Design theme;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (prefs.getString("theme")) {
    case "custom":
      {
        int _primary = prefs.getInt("primary");
        int _accent = prefs.getInt("accent");
        bool _brightness = prefs.getBool("brightness");
        theme = Design("custom",
            ThemeData(
                primaryColor: Color(_primary),
                accentColor: Color(_accent),
                brightness: _brightness ? Brightness.dark : Brightness.light
            ));
        break;
      }
    case "dark":
      {
        theme = dark;
        break;
      }
    case "light":
      {
        theme = light;
        break;
      }
    case "purpledark":
      {
        theme = purpleDark;
        break;
      }
    case "purplelight":
      {
        theme = purpleLight;
        break;
      }
    default:
      {
        theme = light;
        break;
      }
  }
  runApp(new TodoListApp(theme: theme));
}

class TodoListApp extends StatefulWidget {
  TodoListApp({Key key, this.theme}) : super(key: key);

  final Design theme;

  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: widget.theme.data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) =>
          TodoProvider(
            todoBloc: TodoBloc(),
            child: MaterialApp(
              title: 'To-Do List',
              theme: snapshot.data,
              home: MyHomePage(
                title: 'To-Do List',
                themeBloc: _themeBloc,
              ),
            ),
          ),
    );
  }
}
