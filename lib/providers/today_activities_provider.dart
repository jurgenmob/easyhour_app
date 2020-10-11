import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/today_activity.dart';

import 'base_provider.dart';

class TodayActivitiesProvider extends BaseProvider<TodayActivity> {
  @override
  Future<List<TodayActivity>> get() => restGet(EasyRest().getTodayActivities());
}
