import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyAppBarProvider extends ChangeNotifier {
  IconData get icon => _icon;
  IconData _icon;

  String get page => _page;
  String _page;

  EasyAppBarProvider() {
    // Set the default action
    setAction(EasyAppBarAction.calendar());
  }

  void setAction(EasyAppBarAction action) {
    _icon = action?.icon;
    _page = action?.page;

    notifyListeners();
  }
}

class EasyAppBarAction {
  final IconData icon;
  final String page;

  EasyAppBarAction(this.icon, {this.page});

  EasyAppBarAction.calendar() : this(Icons.calendar_today, page: '/calendar');

  EasyAppBarAction.addEditVacation() : this(Icons.add, page: '/vacation/add');

  EasyAppBarAction.addEditPermit() : this(Icons.add, page: '/permit/add');

  EasyAppBarAction.addEditSickness() : this(Icons.add, page: '/sickness/add');

  EasyAppBarAction.addEditSmartWorking()
      : this(Icons.add, page: '/smartworking/add');

  EasyAppBarAction.addEditTrip() : this(Icons.add, page: '/trip/add');

  EasyAppBarAction.addEditActivity() : this(Icons.add, page: '/activity/add');

  static EasyAppBarAction addEditAction(Type t) {
    switch (t) {
      case Vacation:
        return EasyAppBarAction.addEditVacation();
      case Permit:
        return EasyAppBarAction.addEditPermit();
      case Sickness:
        return EasyAppBarAction.addEditSickness();
      case SmartWorking:
        return EasyAppBarAction.addEditSmartWorking();
      case Trip:
        return EasyAppBarAction.addEditTrip();
      case Activity:
        return EasyAppBarAction.addEditActivity();
    }
    return null;
  }
}
