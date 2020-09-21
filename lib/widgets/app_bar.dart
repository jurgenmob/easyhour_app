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
          if (model.icon != null)
            IconButton(
              icon: Icon(model.icon),
              onPressed: () async {
                if (model.page != null) {
                  final previousAction =
                      EasyAppBarAction(model.icon, page: model.page);
                  var result = await Navigator.pushNamed(context, model.page);
                  if (result != null) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("$result")));
                  }
                  Provider.of<EasyAppBarProvider>(context, listen: false)
                      .setAction(previousAction);
                }
              },
            ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
