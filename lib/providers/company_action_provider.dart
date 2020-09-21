import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/company_action.dart';
import 'package:easyhour_app/models/user_info.dart';
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
              page: '/vacation/list'),
          CompanyAction(
              text: LocaleKeys.label_permits,
              icon: EasyIcons.permits,
              page: '/permit/list'),
          CompanyAction(
              text: LocaleKeys.label_sicknesses,
              icon: EasyIcons.sickness,
              page: '/sickness/list'),
          CompanyAction(
              text: LocaleKeys.label_trips,
              icon: EasyIcons.trips,
              page: '/trip/list'),
          if (activeModules.contains(Module(id: activitiesModuleId)))
            CompanyAction(
                text: LocaleKeys.label_activities,
                icon: EasyIcons.activities,
                page: '/activity/list'),
          if (activeModules.contains(Module(id: smartWorkingModuleId)))
            CompanyAction(
                text: LocaleKeys.label_smartworkings,
                icon: EasyIcons.smartworking,
                page: '/smartworking/list'),
        ]);
  }

  @override
  Future<List<CompanyAction>> get() => restGet(getActions());
}
