import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/worklog.dart';

import 'base_provider.dart';

class TodayActivitiesProvider extends BaseProvider<TodayActivity> {
  @override
  Future<List<TodayActivity>> get() => restGet(EasyRest().getTodayActivities());

  Task getTask(Task task) => allItems.where((e) => e == task).first as Task;

  void addEditWorklog(Worklog worklog) {
    final activityTask = getTask(worklog.task);
    final pos = activityTask.worklogs.indexOf(worklog);
    if (pos >= 0) {
      activityTask.worklogs.setRange(pos, pos, [worklog]);
    } else {
      activityTask.worklogs.add(worklog);
    }

    notifyListeners();
  }

  void deleteWorklog(Worklog worklog) {
    getTask(worklog.task).worklogs.remove(worklog);

    notifyListeners();
  }
}
