import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen<T extends BaseModel> extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  final firebaseMessaging = FirebaseMessaging();

  Widget getBody();

  List<EasyRoute> getAppBarRoutes() => [EasyRoute.addEdit(T)];

  void _initScreen(BuildContext context) {
    context.read<EasyAppBarProvider>().actions = getAppBarRoutes();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Push onMessage: $message");
        showMessage(message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("Push onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("Push onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set AppBar action
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScreen(context));

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: EasyAppBar(),
        body: getBody(),
      ),
    );
  }

  @protected
  void showMessage(String message) {
    _scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

abstract class BaseAddEditScreen<T extends BaseModel> extends BaseScreen<T> {
  @override
  List<EasyRoute> getAppBarRoutes() => null;
}
