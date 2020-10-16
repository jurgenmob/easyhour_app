import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/providers/office_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class OfficeListScreen extends BaseScreen<Office> {
  @override
  Widget getBody() => _OfficeListScreen();
}

class _OfficeListScreen extends StatefulWidget {
  @override
  createState() => _OfficeListScreenState();
}

class _OfficeListScreenState
    extends EasyListState<_OfficeListScreen, Office, OfficeProvider> {
  _OfficeListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_offices));
}
