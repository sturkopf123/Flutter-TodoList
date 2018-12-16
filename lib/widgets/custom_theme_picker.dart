import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_v2/bloc/themesBloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return SettingsButton(
      text: "Eigenes Design",
      icon: Icons.color_lens,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
                  title: Text("Farben wählen"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SimpleDialogOption(
                        child: Text("Hauptfarbe"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    titlePadding: EdgeInsets.all(0.0),
                                    contentPadding: EdgeInsets.all(0.0),
                                    content: SingleChildScrollView(
                                        child: MaterialPicker(
                                      onColorChanged: _changePrimary,
                                      pickerColor: _initPrimary,
                                      enableLabel: false,
                                    )));
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SimpleDialogOption(
                        child: Text("Akzentfarbe"),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    titlePadding: EdgeInsets.all(0.0),
                                    contentPadding: EdgeInsets.all(0.0),
                                    content: SingleChildScrollView(
                                        child: MaterialPicker(
                                      onColorChanged: _changeAccent,
                                      pickerColor: _initAccent,
                                      enableLabel: false,
                                    )));
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                    FlatButton(
                        onPressed: () {
                          widget.themeBloc.selectedTheme
                              .add(_buildCustomTheme());
                          _storeCustomThemeData();
                          Navigator.pop(context, false);
                        },
                        child: Text("Speichern"))
                  ],
                ));
      },
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
