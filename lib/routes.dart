import 'package:flutter/material.dart';

class EasyRoute {
  final IconData icon;
  final String page;

  EasyRoute(this.page, {this.icon});

  EasyRoute.home() : this('/home');

  EasyRoute.login() : this('/login');

  EasyRoute.calendar() : this('/calendar', icon: Icons.calendar_today);

  EasyRoute.list(Type T) : this("/${T.toString().toLowerCase()}/list");

  EasyRoute.addEdit(Type T)
      : this("/${T.toString().toLowerCase()}/add-edit", icon: Icons.add);

  @override
  String toString() {
    return 'EasyRoute{page: $page}';
  }
}
