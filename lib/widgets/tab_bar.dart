import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';

class EasyTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = Theme.of(context).textTheme.headline3.fontSize;

    return new TabBar(
      tabs: [
        Tab(
          icon: new Icon(EasyIcons.home, size: iconSize),
        ),
        Tab(
          icon: new Icon(EasyIcons.company, size: iconSize),
        ),
        Tab(
          icon: new Icon(EasyIcons.profile, size: iconSize),
        )
      ],
      labelColor: Theme.of(context).primaryColor,
    );
  }
}
