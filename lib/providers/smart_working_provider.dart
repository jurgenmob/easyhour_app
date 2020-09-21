import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/smart_working.dart';

import 'base_provider.dart';

class SmartWorkingProvider extends BaseProvider<SmartWorking> {
  @override
  Future<List<SmartWorking>> get() => restGet(EasyRest().getSmartWorkings());

  @override
  Future<SmartWorking> add(SmartWorking item) =>
      restAdd(EasyRest().addEditSmartWorking(item));

  @override
  Future<SmartWorking> edit(SmartWorking item) =>
      restEdit(EasyRest().addEditSmartWorking(item));

  @override
  Future<bool> delete(SmartWorking item) =>
      restDelete(item, EasyRest().deleteSmartWorking(item));
}
