import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'sickness.dart';
import 'timer.dart';
import 'vacation.dart';
import 'worklog.dart';

// https://javiercbk.github.io/json_to_dart/
class Task with BaseModel, TodayActivity {
  String nomeTask;
  String nome;
  String nomeProgetto;
  String nomeCliente;
  int idTask;
  List<Worklog> worklogs;
  String serverTime;
  Timer timer;
  int durata = 0;
  String dataModificaTask;

  Task(
      {this.nomeTask,
      this.nomeProgetto,
      this.nomeCliente,
      this.idTask,
      this.worklogs,
      this.serverTime,
      this.timer,
      this.durata,
      this.dataModificaTask});

  @override
  int get id => idTask;

  @override
  DateTimeRange get dateRange => null;

  @override
  bool filter(dynamic filter) =>
      nomeTask?.containsIgnoreCase(filter.toString()) == true ||
      nomeProgetto?.containsIgnoreCase(filter.toString()) == true ||
      nomeCliente?.containsIgnoreCase(filter.toString()) == true;

  @override
  String get listTitle => nomeTask;

  @override
  bool get dismissible => false;

  int get duration => worklogs.fold(0, (p, c) => p + c.durata);

  @override
  Provider provider(BuildContext context) => null;

  @override
  String toString() {
    return 'Task{nomeTask: $nomeTask, nomeProgetto: $nomeProgetto, nomeCliente: $nomeCliente, idTask: $idTask}';
  }

  Task.fromJson(Map<String, dynamic> json) {
    nomeTask = json['nome_task'];
    nomeProgetto = json['nome_progetto'];
    nomeCliente = json['nome_cliente'];
    idTask = json['id_task'];
    if (json['worklogs'] != null) {
      worklogs = new List<Worklog>();
      json['worklogs'].forEach((v) {
        worklogs.add(new Worklog.fromJson(v));
      });
    }
    serverTime = json['serverTime'];
    timer = json['timer'] != null ? new Timer.fromJson(json['timer']) : null;
    durata = json['durata'];
    dataModificaTask = json['dataModificaTask'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }

  Task.fromWorklogTask(WorklogTask task) {
    nomeTask = task.nome;
    nomeProgetto = task.progetto?.nome;
    nomeCliente = task.progetto?.cliente?.nome;
    idTask = task.id;
  }
}

mixin TodayActivity on BaseModel {
  int get duration => 0;
}

class TodayActivitiesResponse {
  List<TodayActivity> get items => [
        ...tasks,
        ...[ferie],
        ...[malattia]
      ];

  List<Task> tasks;

  Vacation ferie;

  Sickness malattia;

  TodayActivitiesResponse.fromJson(Map<String, dynamic> json) {
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
