import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:flutter/material.dart';

import 'activity.dart';
import 'permit.dart';
import 'sickness.dart';
import 'timer.dart';
import 'trip.dart';
import 'vacation.dart';
import 'worklog.dart';

class Calendar {
  List<Worklog> worklogs;
  List<Sickness> malattias;
  List<Vacation> feries;
  List<Permit> permessos;
  List<Trip> trasfertas;
  List<Holiday> holidays;
  List<Activity> attivitas;
  List<Timer> timers;

  Calendar({
    this.worklogs,
    this.malattias,
    this.feries,
    this.permessos,
    this.trasfertas,
    this.holidays,
    this.attivitas,
    this.timers,
  });

  Calendar.fromJson(Map<String, dynamic> json) {
    if (json['worklogs'] != null) {
      worklogs = new List<Worklog>();
      json['worklogs'].forEach((v) {
        worklogs.add(
            new Worklog.fromJson(v, task: Task.fromCalendarJson(v['task'])));
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
  String get listTitle => description;

  @override
  bool get dismissible => false;

  @override
  DateTimeRange get dateRange =>
      date != null ? DateTimeRange(start: date, end: date) : null;

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
        ..._calendar.worklogs.where((e) => e.durata > 0),
        ..._calendar.malattias,
        ..._calendar.feries,
        ..._calendar.permessos,
        ..._calendar.trasfertas,
        ..._calendar.attivitas,
        ..._calendar.holidays,
      ];

  CalendarResponse.fromJson(Map<String, dynamic> json) {
    _calendar = Calendar.fromJson(json);
  }
}
