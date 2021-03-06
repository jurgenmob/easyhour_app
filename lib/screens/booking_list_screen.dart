import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/providers/booking_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';

class BookingListScreen extends BaseScreen<Booking> {
  @override
  List<EasyRoute> getAppBarRoutes(context) => [
        if (userInfo.isReporter) EasyRoute.list(Office, icon: Icons.settings),
        EasyRoute.addEdit(Booking)
      ];

  @override
  Widget getBody() => _BookingListScreen();
}

class _BookingListScreen extends StatefulWidget {
  @override
  createState() => _BookingListScreenState();
}

class _BookingListScreenState
    extends EasyListState<_BookingListScreen, Booking, BookingProvider> {}
