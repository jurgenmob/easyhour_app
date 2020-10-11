import 'package:easyhour_app/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyAppBarProvider extends ChangeNotifier {
  EasyRoute _action;

  get action => _action;

  set action(EasyRoute action) {
    _action = action;

    notifyListeners();
  }
}
