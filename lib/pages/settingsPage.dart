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
    final ThemeData theme = Theme.of(context);
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
                icon: Icons.color_lens,
                text: "Design",
                onPressed: () {
                  showDemoDialog<String>(
                      context: context,
                      child: SimpleDialog(
                          title: const Text('Design auswählen'),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: DialogDemoItem(
                                  color: theme.primaryColor,
                                  text: 'Helles Design',
                                  onPressed: () {
                                    themeBloc.selectedTheme.add(
                                        _buildLightTheme());
                                    _storeThemeData("light");
                                    Navigator.pop(context, "light");
                                  }
                              ),
                            ),
                            Divider(
                              height: 10.0,
                            ),
                            DialogDemoItem(
                                color: theme.primaryColor,
                                text: 'Dunkles Design',
                                onPressed: () {
                                  themeBloc.selectedTheme.add(
                                      _buildDarkTheme());
                                  _storeThemeData("dark");
                                  Navigator.pop(context, "dark");
                                }
                            ),
                            Divider(
                              height: 10.0,
                            ),
                            DialogDemoItem(
                                color: theme.primaryColor,
                                text: 'Lila (hell)',
                                onPressed: () {
                                  themeBloc.selectedTheme.add(
                                      _buildPurpleLightTheme());
                                  _storeThemeData("purplelight");
                                  Navigator.pop(context, "purplelight");
                                }
                            ),
                            Divider(
                              height: 10.0,
                            ),
                            DialogDemoItem(
                                color: theme.primaryColor,
                                text: 'Lila (dunkel)',
                                onPressed: () {
                                  themeBloc.selectedTheme.add(
                                      _buildPurpleDarkTheme());
                                  _storeThemeData("purpledark");
                                  Navigator.pop(context, "purpledark");
                                }
                            ),
                          ]
                      )
                  );
                },
              ),
              Divider(),
              SettingsButton(
                  icon: Icons.delete,
                  text: "Datenbank löschen",
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

  void showDemoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }


  _storeThemeData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", name);
  }

  Design _buildLightTheme() {
    return light;
  }

  Design _buildDarkTheme() {
    return dark;
  }

  Design _buildPurpleDarkTheme() {
    return purpleDark;
  }

  Design _buildPurpleLightTheme() {
    return purpleLight;
  }
}

class DialogDemoItem extends StatelessWidget {
  const DialogDemoItem({ Key key, this.color, this.text, this.onPressed })
      : super(key: key);

  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text, style: TextStyle(fontSize: 16.0),),
          ),
        ],
      ),
    );
  }
}