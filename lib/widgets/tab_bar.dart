import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';

class EasyTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = Theme.of(context).textTheme.headline3.fontSize;

    return new TabBar(
      tabs: [
        Tab(
          icon: new Icon(EasyIcons.home_filled, size: iconSize),
        ),
        Tab(
          icon: new Icon(EasyIcons.chart_filled, size: iconSize),
        ),
        Tab(
          icon: new Icon(EasyIcons.company_filled, size: iconSize),
        ),
        Tab(
          icon: new Icon(EasyIcons.profile_filled, size: iconSize),
        )
      ],
      labelColor: Theme.of(context).primaryColor,
    );
  }
}
