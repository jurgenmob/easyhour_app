import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/office.dart';

import 'base_provider.dart';

class OfficeProvider extends BaseProvider<Office> {
  @override
  Future<List<Office>> get() => restGet(EasyRest().getOffices());

  @override
  Future<Office> add(Office item) => restAdd(EasyRest().addEditOffice(item));

  @override
  Future<Office> edit(Office item) => restEdit(EasyRest().addEditOffice(item));

  @override
  Future<bool> delete(Office item) =>
      restDelete(item, EasyRest().deleteOffice(item));
}
