import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/screens/profile_screen.dart';
import 'package:easyhour_app/screens/today_activities_screen.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';
import 'company_actions_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: EasyAppBar(),
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
      ),
    );
  }
}
