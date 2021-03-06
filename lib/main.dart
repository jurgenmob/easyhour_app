import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/request.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/activity_provider.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/booking_provider.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/providers/company_action_provider.dart';
import 'package:easyhour_app/providers/location_provider.dart';
import 'package:easyhour_app/providers/office_provider.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:easyhour_app/providers/request_provider.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:easyhour_app/providers/task_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/providers/trip_provider.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/activity_addedit_screen.dart';
import 'package:easyhour_app/screens/activity_list_screen.dart';
import 'package:easyhour_app/screens/booking_addedit_screen.dart';
import 'package:easyhour_app/screens/booking_list_screen.dart';
import 'package:easyhour_app/screens/calendar_screen.dart';
import 'package:easyhour_app/screens/home_screen.dart';
import 'package:easyhour_app/screens/location_list_screen.dart';
import 'package:easyhour_app/screens/login_screen.dart';
import 'package:easyhour_app/screens/office_addedit_screen.dart';
import 'package:easyhour_app/screens/office_list_screen.dart';
import 'package:easyhour_app/screens/permit_addedit_screen.dart';
import 'package:easyhour_app/screens/permit_list_screen.dart';
import 'package:easyhour_app/screens/request_list_screen.dart';
import 'package:easyhour_app/screens/sickness_addedit_screen.dart';
import 'package:easyhour_app/screens/sickness_list_screen.dart';
import 'package:easyhour_app/screens/smart_working_addedit_screen.dart';
import 'package:easyhour_app/screens/smart_working_list_screen.dart';
import 'package:easyhour_app/screens/trip_addedit_screen.dart';
import 'package:easyhour_app/screens/trip_list_screen.dart';
import 'package:easyhour_app/screens/vacation_addedit_screen.dart';
import 'package:easyhour_app/screens/vacation_list_screen.dart';
import 'package:easyhour_app/screens/worklog_addedit_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/rest_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Crashlytics
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set colors for system UI
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: const Color(0xAA00ADE6),
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
              ChangeNotifierProvider(create: (context) => TaskProvider()),
              ChangeNotifierProvider(create: (context) => VacationProvider()),
              ChangeNotifierProvider(create: (context) => PermitProvider()),
              ChangeNotifierProvider(create: (context) => SicknessProvider()),
              ChangeNotifierProvider(create: (context) => TripProvider()),
              ChangeNotifierProvider(create: (context) => ActivityProvider()),
              ChangeNotifierProvider(
                  create: (context) => SmartWorkingProvider()),
              ChangeNotifierProvider(create: (context) => CalendarProvider()),
              ChangeNotifierProvider(create: (context) => LocationProvider()),
              ChangeNotifierProvider(create: (context) => BookingProvider()),
              ChangeNotifierProvider(create: (context) => OfficeProvider()),
              ChangeNotifierProvider(create: (context) => RequestProvider()),
            ],
            child: FutureBuilder(
                future: EasyRest().initClient(),
                builder: (context, snapshot) =>
                    snapshot?.connectionState == ConnectionState.done
                        ? _EasyMaterialApp(context)
                        : Container())));
  }
}

class _EasyMaterialApp extends MaterialApp {
  _EasyMaterialApp(BuildContext context)
      : super(
          title: 'EasyHour',
          theme: appTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: EasyRest().isUserLogged
              ? EasyRoute.home().page
              : EasyRoute.login().page,
          routes: {
            EasyRoute.login().page: (context) => LoginScreen(),
            EasyRoute.home().page: (context) => HomeScreen(),
            EasyRoute.calendar().page: (context) => CalendarScreen(),
            EasyRoute.addEdit(WorkLog).page: (context) =>
                WorklogAddEditScreen(),
            EasyRoute.list(Vacation).page: (context) => VacationListScreen(),
            EasyRoute.addEdit(Vacation).page: (context) =>
                VacationAddEditScreen(),
            EasyRoute.list(Permit).page: (context) => PermitListScreen(),
            EasyRoute.addEdit(Permit).page: (context) => PermitAddEditScreen(),
            EasyRoute.list(Sickness).page: (context) => SicknessListScreen(),
            EasyRoute.addEdit(Sickness).page: (context) =>
                SicknessAddEditScreen(),
            EasyRoute.list(Trip).page: (context) => TripListScreen(),
            EasyRoute.addEdit(Trip).page: (context) => TripAddEditScreen(),
            EasyRoute.list(Activity).page: (context) => ActivityListScreen(),
            EasyRoute.addEdit(Activity).page: (context) =>
                ActivityAddEditScreen(),
            EasyRoute.list(SmartWorking).page: (context) =>
                SmartWorkingListScreen(),
            EasyRoute.addEdit(SmartWorking).page: (context) =>
                SmartWorkingAddEditScreen(),
            EasyRoute.list(Location).page: (context) => LocationListScreen(),
            EasyRoute.list(Booking).page: (context) => BookingListScreen(),
            EasyRoute.addEdit(Booking).page: (context) =>
                BookingAddEditScreen(),
            EasyRoute.list(Office).page: (context) => OfficeListScreen(),
            EasyRoute.addEdit(Office).page: (context) => OfficeAddEditScreen(),
            EasyRoute.list(Request).page: (context) => RequestListScreen(),
          },
        );
}
