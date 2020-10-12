import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class PermitListScreen extends BaseScreen<Permit> {
  @override
  Widget getBody() => _PermitListScreen();
}

class _PermitListScreen extends StatefulWidget {
  @override
  createState() => _PermitListScreenState();
}

class _PermitListScreenState extends EasyListState<Permit, PermitProvider> {
  _PermitListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_permits));
}
