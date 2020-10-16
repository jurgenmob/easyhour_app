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
        actions: model.actions
            ?.map(
              (e) => IconButton(
                icon: Icon(e.icon),
                onPressed: () => _navigate(context, model.actions, e),
              ),
            )
            ?.toList(),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      );
    });
  }

  void _navigate(
      BuildContext context, List<EasyRoute> actions, EasyRoute route) async {
    if (route?.page == null) return;

    // Save old route
    final prev = actions;

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
  }

  @override
  get preferredSize => Size.fromHeight(kToolbarHeight);
}
