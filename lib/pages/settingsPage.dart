import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/themes/custom_themes.dart';
import 'package:todo_v2/widgets/settingsbutton.dart';

class SettingsPage extends StatelessWidget {
  final ThemeBloc themeBloc;
  final TodoBloc todoBloc;

  SettingsPage({Key key, this.themeBloc, this.todoBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Einstellungen",
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SettingsButton(
                onPressed: () {
                  themeBloc.selectedTheme.add(_buildLightTheme());
                  _storeThemeData("light");
                },
                text: "Helles Design",
              ),
              Divider(),
              SettingsButton(
                onPressed: () {
                  themeBloc.selectedTheme.add(_buildDarkTheme());
                  _storeThemeData("dark");
                },
                text: "Dunkles Design",
              ),
              Divider(),
              SettingsButton(
                onPressed: () {
                  themeBloc.selectedTheme.add(_buildPurpleDarkTheme());
                  _storeThemeData("purpleDark");
                },
                text: "Lila Design (dunkel)",
              ),
              Divider(),
              SettingsButton(
                onPressed: () {
                  themeBloc.selectedTheme.add(_buildPurpleLightTheme());
                  _storeThemeData("purplelight");
                },
                text: "Lila Design (hell)",
              ),
              Divider(),
              SettingsButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: new Text("To-Do List"),
                          content: new Text("2018 © Andreas Zimmermann"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Verstanden"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            )
                          ],
                        ));
                  },
                  text: "Über"),
              Divider(),
              SettingsButton(
                  text: "Datenbank löschen",
                  onPressed: () {
                    TodoDatabase db = TodoDatabase.get();
                    db.dropTable();
                    todoBloc.dropTable();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _storeThemeData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", name);
  }

  DemoTheme _buildLightTheme() {
    return light;
  }

  DemoTheme _buildDarkTheme() {
    return dark;
  }

  DemoTheme _buildPurpleDarkTheme() {
    return purpledark;
  }

  DemoTheme _buildPurpleLightTheme() {
    return purplelight;
  }
}
