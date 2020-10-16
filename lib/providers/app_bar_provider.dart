import 'package:easyhour_app/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyAppBarProvider extends ChangeNotifier {
  List<EasyRoute> _actions;

  List<EasyRoute> get actions => _actions;

  set actions(List<EasyRoute> actions) {
    _actions = actions;

    notifyListeners();
  }
}
