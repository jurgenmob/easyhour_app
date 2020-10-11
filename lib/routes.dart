import 'package:flutter/material.dart';

typedef Object ArgumentsFunc();

class EasyRoute {
  final IconData icon;
  final String page;
  final ArgumentsFunc argumentsFunc;

  Object get arguments => argumentsFunc != null ? argumentsFunc() : null;

  EasyRoute(this.page, {this.icon, this.argumentsFunc});

  EasyRoute.home() : this('/home');

  EasyRoute.login() : this('/login');

  EasyRoute.calendar() : this('/calendar', icon: Icons.calendar_today);

  EasyRoute.list(Type T) : this("/${T.toString().toLowerCase()}/list");

  EasyRoute.addEdit(Type T, {ArgumentsFunc arguments})
      : this("/${T.toString().toLowerCase()}/add-edit",
            icon: Icons.add, argumentsFunc: arguments);

  @override
  String toString() {
    return 'EasyRoute{page: $page}';
  }
}
