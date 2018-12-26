import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/bloc/todoBloc.dart';
import 'package:todo_v2/database/database.dart';
import 'package:todo_v2/pages/customThemePage.dart';
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomThemePage(
                                themeBloc: themeBloc,
                                context: context,
                              )));
                },
                text: "Design",
                icon: Icons.color_lens,
              ),
              Divider(),
              SettingsButton(
                  icon: Icons.delete,
                  text: "Alle Daten löschen",
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: new Text("Achtung"),
                          content: new Text(
                              "Wollen Sie wirklich alle Daten löschen?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, "flase");
                                },
                                child: Text("Abbrechen")),
                            FlatButton(
                                onPressed: () {
                                  TodoDatabase db = TodoDatabase.get();
                                  db.dropTable();
                                  todoBloc.dropTable();
                                  _deleteSharedPreferences();
                                  themeBloc.selectedTheme
                                      .add(_buildLightTheme());
                                  Navigator.pop(context, "flase");
                                },
                                child: Text("Löschen")),
                          ],
                        ));
                  }),
              Divider(),
              SettingsButton(
                  icon: Icons.info,
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: new Text("To-Do List"),
                          content: Text(
                              "Andreas Zimmermann, 2018\nGitHub: sturkopf123"),
                        ));
                  },
                  text: "Informationen"),
            ],
          ),
        ),
      ),
    );
  }

  _deleteSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Design _buildLightTheme() {
    return light;
  }
}
