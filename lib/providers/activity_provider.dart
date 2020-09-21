import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/activity.dart';

import 'base_provider.dart';

class ActivityProvider extends BaseProvider<Activity> {
  @override
  Future<List<Activity>> get() => restGet(EasyRest().getActivities());

  @override
  Future<Activity> add(Activity item) =>
      restAdd(EasyRest().addEditActivity(item));

  @override
  Future<Activity> edit(Activity item) =>
      restEdit(EasyRest().addEditActivity(item));

  @override
  Future<bool> delete(Activity item) =>
      restDelete(item, EasyRest().deleteActivity(item));
}
