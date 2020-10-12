import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseModel> extends StatelessWidget {
  Widget getBody();

  EasyRoute getAppBarRoute() => EasyRoute.addEdit(T);

  @override
  Widget build(BuildContext context) {
    // Set AppBar action
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<EasyAppBarProvider>().action = getAppBarRoute());

    return SafeArea(
      child: Scaffold(
        appBar: EasyAppBar(),
        body: getBody(),
      ),
    );
  }
}

abstract class BaseAddEditScreen<T extends BaseModel> extends BaseScreen<T> {
  EasyRoute getAppBarRoute() => null;
}
