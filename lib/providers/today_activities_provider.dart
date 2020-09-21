import 'package:dio/dio.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/worklog.dart';

import 'base_provider.dart';

class TodayActivitiesProvider extends BaseProvider<TodayActivity> {
  @override
  Future<List<TodayActivity>> get() => restGet(EasyRest().getTodayActivities());

  // Task getTask(Worklog worklog) =>
  //     items.where((e) => e is Task && e.worklogs.contains(worklog)).first;

  Future<Worklog> addEditWorklog(Task task, Worklog worklog) async {
    Worklog newWorklog = await EasyRest().addEditWorklog(worklog);
    if (newWorklog != null) {
      final pos = task.worklogs.indexOf(newWorklog);
      if (pos >= 0) {
        task.worklogs.setRange(pos, pos, [newWorklog]);
      } else {
        task.worklogs.add(newWorklog);
      }
    }

    notifyListeners();

    return newWorklog;
  }

  Future<bool> deleteWorklog(Task task, Worklog worklog) async {
    Response response = await EasyRest().deleteWorklog(worklog);
    final bool resultOk = response.statusCode == 200;
    if (resultOk) task?.worklogs?.remove(worklog);

    notifyListeners();

    return resultOk;
  }
}
