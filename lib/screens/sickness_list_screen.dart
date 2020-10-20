import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

class SicknessListScreen extends BaseScreen<Sickness> {
  @override
  Widget getBody() => _SicknessListScreen();
}

class _SicknessListScreen extends StatefulWidget {
  @override
  createState() => _SicknessListScreenState();
}

class _SicknessListScreenState
    extends EasyListState<_SicknessListScreen, Sickness, SicknessProvider> {}
