import 'package:flutter/material.dart';
import 'package:todo_v2/bloc/todoBloc.dart';

class TodoProvider extends InheritedWidget {
  final TodoBloc todoBloc;

  TodoProvider({
    Key key,
    @required this.todoBloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TodoBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TodoProvider) as TodoProvider)
          .todoBloc;
}
