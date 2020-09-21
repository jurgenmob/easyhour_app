import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/permit.dart';

import 'base_provider.dart';

class PermitProvider extends BaseProvider<Permit> {
  @override
  Future<List<Permit>> get() => restGet(EasyRest().getPermits());

  @override
  Future<Permit> add(Permit item) => restAdd(EasyRest().addEditPermit(item));

  @override
  Future<Permit> edit(Permit item) => restEdit(EasyRest().addEditPermit(item));

  @override
  Future<bool> delete(Permit item) =>
      restDelete(item, EasyRest().deletePermit(item));
}
