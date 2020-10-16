import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/providers/location_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class LocationListScreen extends BaseScreen<Location> {
  @override
  List<EasyRoute> getAppBarRoutes() => null;

  @override
  Widget getBody() => _LocationListScreen();
}

class _LocationListScreen extends StatefulWidget {
  @override
  createState() => _LocationListScreenState();
}

class _LocationListScreenState
    extends EasyListState<_LocationListScreen, Location, LocationProvider> {
  _LocationListScreenState() : super(LocaleKeys.message_no_locations.tr());
}
