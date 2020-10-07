import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EasyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EasyAppBarProvider>(
        builder: (_, EasyAppBarProvider model, Widget child) {
      return AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Image.asset(
          'images/logo_or.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
        actions: <Widget>[
          if (model.icon != null)
            IconButton(
              icon: Icon(model.icon),
              onPressed: () => _navigate(model, context),
            ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      );
    });
  }

  void _navigate(EasyAppBarProvider model, BuildContext context) async {
    if (model.page == null) return;

    // Save old route
    final prev = EasyRoute(model.page, icon: model.icon);

    // Navigate to the new route
    var result = await Navigator.pushNamed(context, model.page);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }

    // Restore previous action
    Provider.of<EasyAppBarProvider>(context, listen: false).setAction(prev);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
