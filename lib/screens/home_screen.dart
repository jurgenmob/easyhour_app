import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/screens/company_actions_screen.dart';
import 'package:easyhour_app/screens/my_report_screen.dart';
import 'package:easyhour_app/screens/profile_screen.dart';
import 'package:easyhour_app/screens/today_activities_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends BaseScreen {
  List<EasyRoute> getAppBarRoutes(context) => [EasyRoute.calendar()];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Init push notifications
      _initPushNotifications();

      // Update the calendar icon
      EasyAppBar.updateCalendarIndicator(context);
    });

    return super.build(context);
  }

  @override
  Widget getBody() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: DoubleBackToCloseApp(
          child: Center(
            child: TabBarView(
              children: [
                TodayActivitiesScreen(),
                MyReportScreen(),
                CompanyActionsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          snackBar: SnackBar(
            content: Text(LocaleKeys.message_confirm_app_exit.tr(),
                style: snackBarStyle.copyWith(color: Colors.amberAccent)),
            duration: Duration(milliseconds: 3000),
          ),
        ),
        bottomNavigationBar: EasyTabBar(),
      ),
    );
  }

  void _initPushNotifications() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.getToken().then((String token) {
      // Send token to backend
      print("*** Push token ***: $token");
      if (token != null) EasyRest().updatePushToken(token);
    });
  }
}
