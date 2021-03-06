import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

class SmartWorkingListScreen extends BaseScreen<SmartWorking> {
  @override
  Widget getBody() => _SmartWorkingListScreen();
}

class _SmartWorkingListScreen extends StatefulWidget {
  @override
  createState() => _SmartWorkingListScreenState();
}

class _SmartWorkingListScreenState extends EasyListState<
    _SmartWorkingListScreen, SmartWorking, SmartWorkingProvider> {}
