import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/company_action.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/request.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';

import 'base_provider.dart';

class CompanyActionProvider extends BaseProvider<CompanyAction> {
  Future<List<CompanyAction>> getActions() async =>
      Future<List<CompanyAction>>(() => [
            if (userInfo.isManager)
              CompanyAction(
                  text: LocaleKeys.label_requests,
                  icon: EasyIcons.requests,
                  route: EasyRoute.list(Request)),
            CompanyAction(
                text: LocaleKeys.label_vacations,
                icon: EasyIcons.vacations,
                route: EasyRoute.list(Vacation)),
            CompanyAction(
                text: LocaleKeys.label_permits,
                icon: EasyIcons.permits,
                route: EasyRoute.list(Permit)),
            CompanyAction(
                text: LocaleKeys.label_sicknesses,
                icon: EasyIcons.sickness,
                route: EasyRoute.list(Sickness)),
            CompanyAction(
                text: LocaleKeys.label_trips,
                icon: EasyIcons.trips,
                route: EasyRoute.list(Trip)),
            if (userInfo.hasActivitiesModule)
              CompanyAction(
                  text: LocaleKeys.label_activities,
                  icon: EasyIcons.activities,
                  route: EasyRoute.list(Activity)),
            if (userInfo.hasSmartWorkingModule)
              CompanyAction(
                  text: LocaleKeys.label_smartworkings,
                  icon: EasyIcons.smartworkings,
                  route: EasyRoute.list(SmartWorking)),
            if (userInfo.hasBookingModule)
              CompanyAction(
                  text: LocaleKeys.label_bookings,
                  icon: EasyIcons.workplaces,
                  route: EasyRoute.list(Booking)),
          ]);

  @override
  Future<List<CompanyAction>> get() => restGet(getActions());
}
