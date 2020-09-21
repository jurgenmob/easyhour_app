import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/providers/activity_provider.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class ActivityListScreen extends BaseScreen {
  @override
  Widget getBody() => _ActivityListScreen();

  @override
  EasyAppBarAction getEasyAppBarAction() => EasyAppBarAction.addEditActivity();
}

class _ActivityListScreen extends StatefulWidget {
  @override
  createState() => _ActivityListScreenState();
}

class _ActivityListScreenState
    extends EasyListState<Activity, ActivityProvider> {
  _ActivityListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_activities));
}
