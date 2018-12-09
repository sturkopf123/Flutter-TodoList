import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/themesBloc.dart';

var dark = Design('dark', ThemeData.dark());
var light = Design('light', ThemeData.light());
var purpleDark = Design(
    "purpledark",
    ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent));
var purpleLight = Design(
    "purplelight",
    ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent));
