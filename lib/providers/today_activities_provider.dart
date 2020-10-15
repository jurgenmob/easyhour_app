import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/worklog.dart';

import '../globals.dart';
import 'base_provider.dart';

class TodayActivitiesProvider extends BaseProvider<TodayActivity> {
  @override
  Future<List<TodayActivity>> get() async {
    // Since this provider is the very first one used, this is the best
    // place to initialize user info, at least if anybody can come up
    // with a cleaner (but not more verbose) solution. Moving that in
    // main.dart leads to a poor ux because multiple loaders are shown
    // and we also need to handle non-logged users separately.
    userInfo = await EasyRest().getUserInfo();

    return restGet(EasyRest().getTodayActivities());
  }

  Task getTask(Task task) => allItems.where((e) => e == task).first as Task;

  void addEditWorklog(WorkLog worklog) {
    final activityTask = getTask(worklog.task);
    final pos = activityTask.worklogs.indexOf(worklog);
    if (pos >= 0) {
      activityTask.worklogs.setRange(pos, pos + 1, [worklog]);
    } else {
      activityTask.worklogs.add(worklog);
    }

    notifyListeners();
  }

  void deleteWorklog(WorkLog worklog) {
    getTask(worklog.task).worklogs.remove(worklog);

    notifyListeners();
  }
}
