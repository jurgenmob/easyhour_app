import 'package:easyhour_app/models/task.dart';

import 'base_model.dart';
import 'sickness.dart';
import 'vacation.dart';

mixin TodayActivity on BaseModel {
  int get duration => 0;
}

class TodayActivityResponse {
  List<TodayActivity> get items => [
        ...tasks,
        ...[ferie],
        ...[malattia]
      ];

  List<Task> tasks;

  Vacation ferie;

  Sickness malattia;

  TodayActivityResponse.fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      tasks = new List<Task>();
      json['tasks'].forEach((v) {
        tasks.add(new Task.fromJson(v));
      });
    }
    if (json['malattia'] != null) {
      malattia = Sickness.fromJson(json['malattia']);
    }
    if (json['ferie'] != null) {
      ferie = Vacation.fromJson(json['ferie']);
    }
  }
}
