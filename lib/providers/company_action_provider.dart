import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/company_action.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';

import '../generated/locale_keys.g.dart';
import 'base_provider.dart';

class CompanyActionProvider extends BaseProvider<CompanyAction> {
  Future<List<CompanyAction>> getActions() async {
    // FIXME: should use proxy provider?
    List<Module> activeModules =
        (await EasyRest().getUserInfo()).configurazioneAzienda.modulos;

    return Future<List<CompanyAction>>(() => [
          CompanyAction(
              text: LocaleKeys.label_vacations,
              icon: EasyIcons.vacations,
              page: EasyRoute.list(Vacation).page),
          CompanyAction(
              text: LocaleKeys.label_permits,
              icon: EasyIcons.permits,
              page: EasyRoute.list(Permit).page),
          CompanyAction(
              text: LocaleKeys.label_sicknesses,
              icon: EasyIcons.sickness,
              page: EasyRoute.list(Sickness).page),
          CompanyAction(
              text: LocaleKeys.label_trips,
              icon: EasyIcons.trips,
              page: EasyRoute.list(Trip).page),
          if (activeModules.contains(Module(id: activitiesModuleId)))
            CompanyAction(
                text: LocaleKeys.label_activities,
                icon: EasyIcons.activities,
                page: EasyRoute.list(Activity).page),
          if (activeModules.contains(Module(id: smartWorkingModuleId)))
            CompanyAction(
                text: LocaleKeys.label_smartworkings,
                icon: EasyIcons.smartworking,
                page: EasyRoute.list(SmartWorking).page),
        ]);
  }

  @override
  Future<List<CompanyAction>> get() => restGet(getActions());
}
