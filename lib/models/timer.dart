import 'package:easyhour_app/models/task.dart';

import 'company.dart';
import 'worklog.dart';

class Timer {
  int id;
  DateTime startTime;
  DateTime endTime;
  bool registrato;
  Worklog worklog;
  Company azienda;

  Timer(
      {this.id,
      this.startTime,
      this.endTime,
      this.registrato,
      this.worklog,
      this.azienda});

  Duration get duration => Duration(
      seconds: (endTime ?? DateTime.now()).difference(startTime).inSeconds);

  get active => id != null && startTime != null && endTime == null;

  Timer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['startTime'] != null) {
      startTime = DateTime.parse(json['startTime']);
    }
    if (json['endTime'] != null) {
      endTime = DateTime.parse(json['endTime']);
    }
    registrato = json['registrato'];
    if (json['worklog'] != null) {
      worklog = Worklog.fromJson(json['worklog']);
    }
    if (json['azienda'] != null) {
      azienda = Company.fromJson(json['azienda']);
    }
  }
}

class TimerStartRequest {
  Task task;
  Worklog worklog;

  TimerStartRequest(this.task, this.worklog);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.task.id;
    data['worklog_id'] = this.worklog?.id;

    return data;
  }
}

class TimerStopRequest {
  Timer timer;

  TimerStopRequest(this.timer);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timer_id'] = this.timer.id;

    return data;
  }
}
