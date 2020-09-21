import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class SicknessListScreen extends BaseScreen {
  @override
  Widget getBody() => _SicknessListScreen();

  @override
  EasyAppBarAction getEasyAppBarAction() => EasyAppBarAction.addEditSickness();
}

class _SicknessListScreen extends StatefulWidget {
  @override
  createState() => _SicknessListScreenState();
}

class _SicknessListScreenState
    extends EasyListState<Sickness, SicknessProvider> {
  _SicknessListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_sicknesses));
}
