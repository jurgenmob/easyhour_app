import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/sickness.dart';

import 'base_provider.dart';

class SicknessProvider extends BaseProvider<Sickness> {
  @override
  Future<List<Sickness>> get() => restGet(EasyRest().getSicknesses());

  @override
  Future<Sickness> add(Sickness item) =>
      restAdd(EasyRest().addEditSickness(item));

  @override
  Future<Sickness> edit(Sickness item) =>
      restEdit(EasyRest().addEditSickness(item));

  @override
  Future<bool> delete(Sickness item) =>
      restDelete(item, EasyRest().deleteSickness(item));
}
