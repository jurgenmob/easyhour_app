import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

class PermitListScreen extends BaseScreen<Permit> {
  @override
  Widget getBody() => _PermitListScreen();
}

class _PermitListScreen extends StatefulWidget {
  @override
  createState() => _PermitListScreenState();
}

class _PermitListScreenState
    extends EasyListState<_PermitListScreen, Permit, PermitProvider> {}
