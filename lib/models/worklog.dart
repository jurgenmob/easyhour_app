import 'package:easyhour_app/data/rest_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'calendar.dart';
import 'task.dart';
import 'user.dart';

class Worklog with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  DateTime data;
  int durata;
  User user;
  Task task;
  String fase;

  Worklog(
      {this.id,
      this.descrizione,
      this.data,
      this.durata,
      this.user,
      this.task,
      this.fase});

  @override
  String get listTitle => task?.nomeTask;

  @override
  String get listSuptitle => task?.nomeCliente;

  @override
  String get listSubtitle => task?.nomeProgetto;

  @override
  String get listDetailsTop => data.formatDisplay();

  @override
  String get listDetailsBtm => durationString;

  String get durationString {
    final int hour = durata ~/ 60;
    final int minutes = durata % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  @override
  bool get dismissible => true;

  @override
  DateTimeRange get dateRange => data != null ? dateRangeFromDate(data) : null;

  @override
  Provider provider(BuildContext context) => null;

  @override
  String toString() {
    return 'Worklog{data: $data, durata: $durata, task: $task}';
  }

  Worklog.fromJson(Map<String, dynamic> json, {Task task}) {
    id = json['id'];
    descrizione = json['descrizione'];
    data = DateTime.parse(json['data']);
    durata = json['durata'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    this.task = task;
    fase = json['fase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data.formatRest();
    data['descrizione'] = this.descrizione;
    data['durata'] = this.durata;
    if (this.task != null) {
      data['task'] = this.task.toJson();
    }

    return data;
  }
}
