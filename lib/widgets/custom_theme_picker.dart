import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
import 'package:todo_v2/widgets/color_picker.dart';
import 'package:todo_v2/widgets/settingsbutton.dart';

class CustomDesignButton extends StatefulWidget {
  final ThemeBloc themeBloc;

  @override
  _CustomDesignButtonState createState() => _CustomDesignButtonState();

  CustomDesignButton({Key key, this.themeBloc}) : super(key: key);
}

class _CustomDesignButtonState extends State<CustomDesignButton> {
  Color _initPrimary = Color(0xff4db6ac);
  Color _initAccent = Color(0xff80cbc4);
  bool _initBrightness = false;

  Color _tempPrimary = Colors.white;
  Color _tempAccent = Colors.black;
  @override
  void initState() {
    super.initState();
    _initColors();
  }

  void _initColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("primary") != null) {
      _initPrimary = Color(prefs.getInt("primary"));
    }
    if (prefs.getInt("accent") != null) {
      _initAccent = Color(prefs.getInt("accent"));
    }
    if (prefs.getBool("brightness") != null) {
      _initBrightness = prefs.getBool("brightness");
    }
  }

  Widget _getCurrentColor() {
    return Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
          color: _initPrimary,
          shape: BoxShape.rectangle
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsButton(
      text: "Eigenes Design",
      icon: Icons.color_lens,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Farben wählen"),
              ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: SimpleDialogOption(
                        child: Text("Hauptfarbe"),
                        onPressed: () {
                          showDemoDialog(
                              context: context,
                              child: SimpleDialog(
                                children: <Widget>[
                                  ColorPicker(
                                    currentColor: _initPrimary,
                                    onSelected: (Color color) {
                                      _tempPrimary = color;
                                    },
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
                                            _changePrimary(_tempPrimary);
                                            Navigator.pop(context, false);
                                          },
                                          child: Text("Okay"))
                                    ],
                                  )
                                ],
                              )
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: SimpleDialogOption(
                        child: Text("Akzentfarbe"),
                        onPressed: () {
                          showDemoDialog(
                              context: context,
                              child: SimpleDialog(
                                children: <Widget>[
                                  ColorPicker(
                                    currentColor: _initAccent,
                                    onSelected: (Color color) {
                                      _tempAccent = color;
                                    },
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
                                            _changeAccent(_tempAccent);
                                            Navigator.pop(context, false);
                                          },
                                          child: Text("Okay"))
                                    ],
                                  )
                                ],
                              )
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 8.0, right: 8.0,),
                      child: SimpleDialogOption(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Dunkler Modus:"),
                            Switch(
                                value: _initBrightness,
                                onChanged: (bool value) {
                                  setState(() {
                                    _changeBrightness(value);
                                  });
                                })
                          ],
                        ),
                      ),
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
                              widget.themeBloc.selectedTheme
                                  .add(_buildCustomTheme());
                              _storeCustomThemeData();
                              Navigator.pop(context, false);
                            },
                            child: Text("Speichern"))
                      ],
                    )
                  ],
                ));
      },
    );
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Design _buildCustomTheme() {
    print("$_initPrimary");
    print(_initAccent);
    print(_initBrightness);
    return Design(
        "custom",
        ThemeData(
            primaryColor: _initPrimary,
            accentColor: _initAccent,
            brightness: _initBrightness ? Brightness.dark : Brightness.light));
  }

  void _changeBrightness(bool bool) {
    setState(() {
      _initBrightness = bool;
    });
  }

  void _changePrimary(Color color) {
    setState(() {
      _initPrimary = color;
    });
  }

  void _changeAccent(Color color) {
    setState(() {
      _initAccent = color;
    });
  }

  _storeCustomThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("${_initPrimary.value}, ${_initAccent.value}, $_initBrightness");
    await prefs.setString("theme", "custom");
    await prefs.setInt("primary", _initPrimary.value);
    await prefs.setInt("accent", _initAccent.value);
    await prefs.setBool("brightness", _initBrightness);
  }
}
