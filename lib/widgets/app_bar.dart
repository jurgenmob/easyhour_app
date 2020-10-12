import 'package:easyhour_app/providers/app_bar_provider.dart';
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
          if (model.action?.icon != null)
            IconButton(
              icon: Icon(model.action.icon),
              onPressed: () => _navigate(model, context),
            ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      );
    });
  }

  void _navigate(EasyAppBarProvider model, BuildContext context) async {
    if (model.action?.page == null) return;

    // Save old route
    final prev = model.action;

    // Navigate to the new route or call the callback
    var result = await Navigator.pushNamed(context, model.action.page,
        arguments: model.action.arguments);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }

    // Restore previous action
    context.read<EasyAppBarProvider>().action = prev;
  }

  @override
  get preferredSize => Size.fromHeight(kToolbarHeight);
}
