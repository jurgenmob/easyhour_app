import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class VacationListScreen extends BaseScreen<Vacation> {
  @override
  Widget getBody() => _VacationListScreen();
}

class _VacationListScreen extends StatefulWidget {
  @override
  createState() => _VacationListScreenState();
}

class _VacationListScreenState
    extends EasyListState<_VacationListScreen, Vacation, VacationProvider> {
  _VacationListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_vacations));
}
