import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/screens/company_actions_screen.dart';
import 'package:easyhour_app/screens/profile_screen.dart';
import 'package:easyhour_app/screens/today_activities_screen.dart';
import 'package:easyhour_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class HomeScreen extends BaseScreen {
  EasyRoute getAppBarRoute() => EasyRoute.calendar();

  HomeScreen() {
    // Init push notifications
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initPushNotifications());
  }

  @override
  Widget getBody() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: DoubleBackToCloseApp(
          child: Center(
            child: TabBarView(
              children: [
                TodayActivitiesScreen(),
                CompanyActionsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          snackBar: SnackBar(
            content: Text(LocaleKeys.message_confirm_app_exit.tr()),
            duration: Duration(milliseconds: 2000),
          ),
        ),
        bottomNavigationBar: EasyTabBar(),
      ),
    );
  }

  void _initPushNotifications() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.getToken().then((String token) {
      // TODO: sent token to server when API will be available
      print("*** Push token ***: $token");
    });
  }
}
