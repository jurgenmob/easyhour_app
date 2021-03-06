import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:flutter/material.dart';

import 'activity.dart';
import 'permit.dart';
import 'sickness.dart';
import 'task.dart';
import 'timer.dart';
import 'trip.dart';
import 'vacation.dart';
import 'worklog.dart';

class Calendar {
  List<WorkLog> worklogs;
  List<Sickness> malattias;
  List<Vacation> feries;
  List<Permit> permessos;
  List<Trip> trasfertas;
  List<Holiday> holidays;
  List<Activity> attivitas;
  List<Timer> timers;

  Calendar.fromJson(Map<String, dynamic> json) {
    if (json['worklogs'] != null) {
      worklogs = new List<WorkLog>();
      json['worklogs'].forEach((v) {
        worklogs.add(new WorkLog.fromJson(v, task: Task.fromJson(v['task'])));
      });
    }
    if (json['malattias'] != null) {
      malattias = new List<Sickness>();
      json['malattias'].forEach((v) {
        malattias.add(new Sickness.fromJson(v));
      });
    }
    if (json['feries'] != null) {
      feries = new List<Vacation>();
      json['feries'].forEach((v) {
        feries.add(new Vacation.fromJson(v));
      });
    }
    if (json['permessos'] != null) {
      permessos = new List<Permit>();
      json['permessos'].forEach((v) {
        permessos.add(new Permit.fromJson(v));
      });
    }
    if (json['trasfertas'] != null) {
      trasfertas = new List<Trip>();
      json['trasfertas'].forEach((v) {
        trasfertas.add(new Trip.fromJson(v));
      });
    }
    if (json['holidays'] != null) {
      holidays = new List<Holiday>();
      json['holidays'].forEach((v) {
        holidays.add(new Holiday.fromJson(v));
      });
    }
    if (json['attivitas'] != null) {
      attivitas = new List<Activity>();
      json['attivitas'].forEach((v) {
        attivitas.add(new Activity.fromJson(v));
      });
    }
    if (json['timers'] != null) {
      timers = new List<Timer>();
      json['timers'].forEach((v) {
        timers.add(new Timer.fromJson(v));
      });
    }
  }
}

class Holiday with BaseModel, CalendarEvent {
  DateTime date;
  String propertiesKey;
  String type;
  String description;

  Holiday({this.date, this.propertiesKey, this.type, this.description});

  @override
  get id => date.millisecondsSinceEpoch;

  @override
  get listTitle => description;

  @override
  get dismissible => false;

  @override
  get dateRange => date != null ? dateRangeFromDate(date) : null;

  @override
  Duration duration(DateTime date) => userInfo.targetHours(date);

  @override
  provider(BuildContext context) => null;

  Holiday.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    propertiesKey = json['propertiesKey'];
    type = json['type'];
    description = json['description'];
  }
}

/// An event with a date range, to be represented in a calendar
mixin CalendarEvent on BaseModel {
  DateTimeRange get dateRange;

  /// The duration of the event, in minutes
  Duration duration(DateTime date);

  @override
  bool filter(f) {
    DateTime filter = DateTime(f.year, f.month, f.day, 0, 0, 0, 0, 0);
    return filter.compareTo(dateRange.start) >= 0 &&
        filter.compareTo(dateRange.end) <= 0;
  }
}

class CalendarResponse {
  Calendar _calendar;

  List<CalendarEvent> get items => [
        if (_calendar.worklogs != null)
          ..._calendar.worklogs?.where((e) => e.durata > 0),
        if (_calendar.malattias != null) ..._calendar.malattias,
        if (_calendar.feries != null) ..._calendar.feries,
        if (_calendar.permessos != null) ..._calendar.permessos,
        if (_calendar.trasfertas != null) ..._calendar.trasfertas,
        if (_calendar.attivitas != null) ..._calendar.attivitas,
        if (_calendar.holidays != null) ..._calendar.holidays,
      ];

  CalendarResponse.fromJson(Map<String, dynamic> json) {
    _calendar = Calendar.fromJson(json);
  }
}
