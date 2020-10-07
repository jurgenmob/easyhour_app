import 'package:easyhour_app/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyAppBarProvider extends ChangeNotifier {
  IconData get icon => _icon;
  IconData _icon;

  String get page => _page;
  String _page;

  void setAction(EasyRoute action) {
    _icon = action?.icon;
    _page = action?.page;

    notifyListeners();
  }
}
