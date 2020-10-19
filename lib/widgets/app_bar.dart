import 'package:badges/badges.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EasyAppBar extends StatelessWidget with PreferredSizeWidget {
  static List<EasyRoute> _actions;

  static dynamic navigate(BuildContext context, EasyRoute route) async {
    if (route?.page == null) return;

    // Callback only actions
    if (route.callback != null) {
      return route.callback();
    }

    // Save old route
    final prev = List<EasyRoute>.from(_actions);

    // Navigate to the new route or call the callback
    var result = await Navigator.pushNamed(context, route.page,
        arguments: route.arguments);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }

    // Restore previous action
    context.read<EasyAppBarProvider>().actions = prev;

    // Update the calendar icon
    if (prev.contains(EasyRoute.calendar())) {
      EasyAppBar.updateCalendarIndicator(context);
    }

    return result;
  }

  static void updateCalendarIndicator(BuildContext context,
      {DateTimeRange dateRange}) async {
    final provider = context.read<EasyAppBarProvider>();
    final calRoute = EasyRoute.calendar();
    final route =
        provider.actions?.firstWhere((e) => e == calRoute, orElse: () => null);
    if (route != null) {
      route.indicator = null;
      // notify listeners
      provider.actions = provider.actions;
      // Update indicator
      route.indicator = await context
          .read<CalendarProvider>()
          .monthIndicator(dateRange: dateRange);
      // notify listeners
      provider.actions = provider.actions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EasyAppBarProvider>(
        builder: (_, EasyAppBarProvider model, Widget child) {
      // Save last actions
      _actions = model.actions;

      return AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Image.asset(
          'images/logo_or.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
        actions: model.actions
            ?.where((e) => e != null)
            ?.map((e) => _buildIcon(context, e))
            ?.toList(),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      );
    });
  }

  Widget _buildIcon(BuildContext context, EasyRoute route) => GestureDetector(
        onTap: () => navigate(context, route),
        child: Stack(children: [
          IconButton(
            icon: route.icon,
            onPressed: () => navigate(context, route),
          ),
          if (route.indicator != null)
            Positioned(
              bottom: 6,
              right: 6,
              child: Badge(
                badgeColor: route.indicator.background,
                borderRadius: 20,
                padding: EdgeInsets.all(
                    route.indicator.text?.isNotEmpty == true ? 2 : 4),
                shape: route.indicator.text?.isNotEmpty == true
                    ? BadgeShape.square
                    : BadgeShape.circle,
                badgeContent: Text(
                  route.indicator.text,
                  style: TextStyle(
                      color: route.indicator.foreground, fontSize: 12),
                ),
              ),
            )
        ]),
      );

  @override
  get preferredSize => Size.fromHeight(kToolbarHeight);
}
