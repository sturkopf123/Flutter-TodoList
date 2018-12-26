import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/widgets/helperWidgets.dart';

class CustomThemePage extends StatefulWidget {
  final ThemeBloc themeBloc;
  final BuildContext context;

  @override
  _CustomThemePageState createState() => _CustomThemePageState();

  CustomThemePage({Key key, this.themeBloc, this.context}) : super(key: key);
}

class _CustomThemePageState extends State<CustomThemePage> {
  Color _oldPrimaryColor;

  Color _primaryColor;
  Color _accentColor;

  Color _tempPrimaryColor;
  Color _tempAccentColor;

  bool _checker;

  @override
  void initState() {
    super.initState();
    _initColors();
  }

  void _initColors() {
    _primaryColor = Theme
        .of(widget.context)
        .primaryColor;
    _accentColor = Theme
        .of(widget.context)
        .accentColor;
    _checker =
    Theme
        .of(widget.context)
        .brightness == Brightness.dark ? true : false;
    _oldPrimaryColor = Theme
        .of(widget.context)
        .accentColor;
  }

  _storeCustomThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", "custom");
    await prefs.setInt("primary", _primaryColor.value);
    await prefs.setInt("accent", _accentColor.value);
    await prefs.setBool("brightness", _checker);
  }

  Design _buildCustomTheme() {
    return Design(
        "custom",
        ThemeData(
            primaryColor: _primaryColor,
            accentColor: _accentColor,
            brightness: _checker ? Brightness.dark : Brightness.light));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Design erstellen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                showDemoDialog(
                    context: context,
                    child: SimpleDialog(
                      title: Text("Hauptfarbe wählen"),
                      children: <Widget>[
                        MaterialColorPicker(
                          onColorChange: (Color color) {
                            _tempPrimaryColor = color;
                          },
                          selectedColor: _primaryColor,
                          circleSize: 50.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text("Abbrechen")),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _primaryColor = _tempPrimaryColor;
                                  });
                                  Navigator.pop(context, false);
                                },
                                child: Text("Okay"))
                          ],
                        )
                      ],
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Hauptfarbe", style: Theme
                      .of(context)
                      .textTheme
                      .body2),
                  CircleColor(color: _primaryColor, circleSize: 30.0)
                ],
              ),
            ),
            Divider(),
            FlatButton(
              onPressed: () {
                showDemoDialog(
                    context: context,
                    child: SimpleDialog(
                      title: Text("Akzentfarbe wählen"),
                      children: <Widget>[
                        MaterialColorPicker(
                          onColorChange: (Color color) {
                            _tempAccentColor = color;
                          },
                          selectedColor: _accentColor,
                          circleSize: 50.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text("Abbrechen")),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _accentColor = _tempAccentColor;
                                  });
                                  Navigator.pop(context, false);
                                },
                                child: Text("Okay"))
                          ],
                        )
                      ],
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Akzentfarbe", style: Theme
                      .of(context)
                      .textTheme
                      .body2),
                  CircleColor(color: _accentColor, circleSize: 30.0),
                ],
              ),
            ),
            Divider(),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Dunkler Modus:"),
                  CircleAvatar(
                    radius: 15.0,
                    backgroundColor: Colors.transparent,
                    child: Checkbox(
                        value: _checker,
                        onChanged: (bool val) {
                          setState(() {
                            _checker = val;
                          });
                        }),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Abbrechen")),
        FlatButton(
            onPressed: () {
              widget.themeBloc.selectedTheme.add(_buildCustomTheme());
              _storeCustomThemeData();
              setState(() {
                _oldPrimaryColor = _accentColor;
              });
            },
            child: Text("Speichern"))
      ],
    );
  }
}
