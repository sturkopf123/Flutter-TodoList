import 'package:flutter/material.dart';
import 'package:todo_v2/bloc_old/todo_bloc.dart';


class TodoBlocProvider extends InheritedWidget{
  final TodoBloc todoBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TodoBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TodoBlocProvider) as TodoBlocProvider)
          .todoBloc;

  TodoBlocProvider({Key key, TodoBloc todoBloc, Widget child})
      : this.todoBloc = todoBloc ?? TodoBloc(),
        super(child: child, key: key);
}