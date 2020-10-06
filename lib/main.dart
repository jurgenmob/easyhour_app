import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/providers/activity_provider.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/providers/company_action_provider.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/providers/trip_provider.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:easyhour_app/screens/activity_add_screen.dart';
import 'package:easyhour_app/screens/activity_list_screen.dart';
import 'package:easyhour_app/screens/calendar_screen.dart';
import 'package:easyhour_app/screens/home_screen.dart';
import 'package:easyhour_app/screens/login_screen.dart';
import 'package:easyhour_app/screens/permit_add_screen.dart';
import 'package:easyhour_app/screens/permit_list_screen.dart';
import 'package:easyhour_app/screens/sickness_add_screen.dart';
import 'package:easyhour_app/screens/sickness_list_screen.dart';
import 'package:easyhour_app/screens/smart_working_add_screen.dart';
import 'package:easyhour_app/screens/smart_working_list_screen.dart';
import 'package:easyhour_app/screens/trip_add_screen.dart';
import 'package:easyhour_app/screens/trip_list_screen.dart';
import 'package:easyhour_app/screens/vacation_add_screen.dart';
import 'package:easyhour_app/screens/vacation_list_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  // Force portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set colors for system UI
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Color(0xAA00ADE6),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Run app!
  runApp(EasyApp());
}

class EasyApp extends StatefulWidget {
  @override
  createState() => _EasyAppState();
}

class _EasyAppState extends State<EasyApp> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: [Locale('en'), Locale('it')],
        fallbackLocale: Locale('en'),
        assetLoader: JsonAssetLoader(),
        path: 'assets/translations',
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => EasyAppBarProvider()),
              ChangeNotifierProvider(
                  create: (context) => CompanyActionProvider()),
              ChangeNotifierProvider(
                  create: (context) => TodayActivitiesProvider()),
              ChangeNotifierProvider(create: (context) => VacationProvider()),
              ChangeNotifierProvider(create: (context) => PermitProvider()),
              ChangeNotifierProvider(create: (context) => SicknessProvider()),
              ChangeNotifierProvider(create: (context) => TripProvider()),
              ChangeNotifierProvider(create: (context) => ActivityProvider()),
              ChangeNotifierProvider(
                  create: (context) => SmartWorkingProvider()),
              ChangeNotifierProvider(create: (context) => CalendarProvider()),
            ],
            child: FutureBuilder<bool>(
              future: EasyRest().isUserLogged(),
              builder: (context, snapshot) =>
                  snapshot?.connectionState == ConnectionState.done
                      ? _EasyMaterialApp(context, isUserLogged: snapshot.data)
                      : Container(),
            )));
  }
}

class _EasyMaterialApp extends MaterialApp {
  _EasyMaterialApp(BuildContext context, {@required bool isUserLogged})
      : super(
          title: 'EasyHour',
          theme: appTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: isUserLogged ? '/home' : '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/calendar': (context) => CalendarScreen(),
            '/vacation/list': (context) => VacationListScreen(),
            '/vacation/add': (context) => VacationAddScreen(),
            '/permit/list': (context) => PermitListScreen(),
            '/permit/add': (context) => PermitAddScreen(),
            '/sickness/list': (context) => SicknessListScreen(),
            '/sickness/add': (context) => SicknessAddScreen(),
            '/trip/list': (context) => TripListScreen(),
            '/trip/add': (context) => TripAddScreen(),
            '/activity/list': (context) => ActivityListScreen(),
            '/activity/add': (context) => ActivityAddScreen(),
            '/smartworking/list': (context) => SmartWorkingListScreen(),
            '/smartworking/add': (context) => SmartWorkingAddScreen(),
          },
        );
}
