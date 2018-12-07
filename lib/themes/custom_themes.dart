
import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/themes.dart';

var dark = DemoTheme(
    'dark',
    ThemeData.dark()
);
var light = DemoTheme(
    'light',
    ThemeData.light()
);
var purpledark = DemoTheme(
    "purpledark",
    ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent
    ));
var purplelight = DemoTheme(
    "purplelight",
    ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent
    ));