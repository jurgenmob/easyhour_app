import 'package:dio/dio.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_provider.dart';

class TaskProvider extends BaseProvider<Task> {
  @override
  Future<List<Task>> get() => restGet(EasyRest().getTasks());

  Task getTask(int id) =>
      items?.firstWhere((e) => e.id == id, orElse: () => null);

  Future<WorkLog> addEditWorklog(
      BuildContext context, Task task, WorkLog worklog) async {
    WorkLog newWorklog = await EasyRest().addEditWorklog(worklog);
    if (newWorklog != null) {
      final pos = task.worklogs.indexOf(newWorklog);
      if (pos >= 0) {
        task.worklogs.setRange(pos, pos + 1, [newWorklog]);
      } else {
        task.worklogs.add(newWorklog);
      }
      // Also add the item to calendar and today activities
      context.read<CalendarProvider>().addEditWorklog(newWorklog);
      context.read<TodayActivitiesProvider>().addEditWorklog(newWorklog);
    }

    notifyListeners();

    return newWorklog;
  }

  Future<bool> deleteWorklog(
      BuildContext context, Task task, WorkLog worklog) async {
    Response response = await EasyRest().deleteWorklog(worklog);
    final bool resultOk = response.statusCode == 200;
    if (resultOk) {
      task?.worklogs?.remove(worklog);

      // Also add the item to calendar and today activities
      context.read<CalendarProvider>().delete(worklog);
      context.read<TodayActivitiesProvider>().deleteWorklog(worklog);

      notifyListeners();
    }

    return resultOk;
  }
}
