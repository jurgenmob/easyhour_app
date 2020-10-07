import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/providers/trip_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class TripListScreen extends BaseScreen<Trip> {
  @override
  Widget getBody() => _TripListScreen();
}

class _TripListScreen extends StatefulWidget {
  @override
  createState() => _TripListScreenState();
}

class _TripListScreenState extends EasyListState<Trip, TripProvider> {
  _TripListScreenState()
      : super(EasyListState.defaultEmptyText(LocaleKeys.label_trips));
}
