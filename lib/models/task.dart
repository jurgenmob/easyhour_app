import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'timer.dart';
import 'today_activity.dart';
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
    nomeTask = json['nome'] ?? json['nome_task'];
    nomeProgetto = json['progetto'] != null
        ? json['progetto']['nome']
        : json['nome_progetto'];
    nomeCliente = json['progetto'] != null
        ? json['progetto']['cliente']['nome']
        : json['nome_cliente'];
    idTask = json['id'] ?? json['id_task'];
    worklogs = new List<Worklog>();
    if (json['worklogs'] != null) {
      json['worklogs'].forEach((v) {
        worklogs.add(new Worklog.fromJson(v, task: this));
      });
    }
    serverTime = json['serverTime'];
    timer = json['timer'] != null ? new Timer.fromJson(json['timer']) : null;
    durata = json['durata'];
    dataModificaTask = json['lastModifiedDate'] ?? json['dataModificaTask'];
  }

  // Task.fromCalendarJson(Map<String, dynamic> json) {
  //   nomeTask = json['nome'];
  //   nomeProgetto = json['progetto']['nome'];
  //   nomeCliente = json['progetto']['cliente']['nome'];
  //   idTask = json['id'];
  //   dataModificaTask = json['lastModifiedDate'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }
}

class TaskResponse {
  List<Task> items;

  TaskResponse({this.items});

  TaskResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Task>();
      json.forEach((v) {
        items.add(new Task.fromJson(v));
      });
    }
  }
}
