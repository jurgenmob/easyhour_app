import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen extends StatelessWidget {
  Widget getBody();

  EasyAppBarAction getEasyAppBarAction();

  @override
  Widget build(BuildContext context) {
    // Set AppBar action
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<EasyAppBarProvider>(context, listen: false)
            .setAction(getEasyAppBarAction()));

    return SafeArea(
      child: Scaffold(
        appBar: EasyAppBar(),
        body: getBody(),
      ),
    );
  }
}
