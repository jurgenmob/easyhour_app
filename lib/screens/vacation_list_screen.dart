import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class VacationListScreen extends BaseScreen {
  @override
  Widget getBody() => _VacationListScreen();

  @override
  EasyAppBarAction getEasyAppBarAction() => EasyAppBarAction.addEditVacation();
}

class _VacationListScreen extends StatefulWidget {
  @override
  createState() => _VacationListScreenState();
}

class _VacationListScreenState
    extends EasyListState<Vacation, VacationProvider> {
  _VacationListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_vacations));
}
