import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/vacation.dart';

import 'base_provider.dart';

class VacationProvider extends BaseProvider<Vacation> {
  @override
  Future<List<Vacation>> get() => restGet(EasyRest().getVacations());

  @override
  Future<Vacation> add(Vacation item) =>
      restAdd(EasyRest().addEditVacation(item));

  @override
  Future<Vacation> edit(Vacation item) =>
      restEdit(EasyRest().addEditVacation(item));

  @override
  Future<bool> delete(Vacation item) =>
      restDelete(item, EasyRest().deleteVacation(item));
}
