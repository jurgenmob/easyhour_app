import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:flutter/material.dart';

typedef Object ArgumentsFunc();

class EasyRoute {
  /// The icon in the app bar
  final Widget icon;

  /// The page to navigate to
  final String page;

  /// If not-null the app bar will call this instead of navigating
  final VoidCallback callback;

  /// If not-null it's used to build arguments when calling Navigator
  final ArgumentsFunc argumentsFunc;

  /// If not-null a small spot with given color is added to the icon
  CalendarIndicator _indicator;

  get indicator => _indicator;

  set indicator(value) => _indicator = value;

  Object get arguments => argumentsFunc != null ? argumentsFunc() : null;

  EasyRoute(this.page,
      {this.icon,
      this.callback,
      this.argumentsFunc,
      CalendarIndicator indicator})
      : _indicator = indicator;

  EasyRoute.home() : this('/home');

  EasyRoute.login() : this('/login');

  EasyRoute.calendar({CalendarIndicator indicator, VoidCallback callback})
      : this('/calendar',
            icon: Icon(callback == null ? Icons.calendar_today : Icons.today),
            indicator: indicator,
            callback: callback);

  EasyRoute.list(Type T, {IconData icon})
      : this("/${T.toString().toLowerCase()}/list", icon: Icon(icon));

  EasyRoute.addEdit(Type T, {ArgumentsFunc arguments})
      : this("/${T.toString().toLowerCase()}/add-edit",
            icon: Icon(Icons.add), argumentsFunc: arguments);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasyRoute &&
          runtimeType == other.runtimeType &&
          page == other.page;

  @override
  int get hashCode => page.hashCode;

  @override
  String toString() {
    return 'EasyRoute{page: $page}';
  }
}
