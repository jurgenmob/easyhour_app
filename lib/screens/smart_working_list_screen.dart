import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class SmartWorkingListScreen extends BaseScreen {
  @override
  Widget getBody() => _SmartWorkingListScreen();

  @override
  EasyAppBarAction getEasyAppBarAction() =>
      EasyAppBarAction.addEditSmartWorking();
}

class _SmartWorkingListScreen extends StatefulWidget {
  @override
  createState() => _SmartWorkingListScreenState();
}

class _SmartWorkingListScreenState
    extends EasyListState<SmartWorking, SmartWorkingProvider> {
  _SmartWorkingListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_smartworkings));
}
