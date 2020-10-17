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
  List<WorkLog> worklogs;
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
  get id => idTask;

  @override
  filter(dynamic filter) =>
      nomeTask?.containsIgnoreCase(filter.toString()) == true ||
      nomeProgetto?.containsIgnoreCase(filter.toString()) == true ||
      nomeCliente?.containsIgnoreCase(filter.toString()) == true;

  @override
  get listTitle => nomeTask;

  @override
  get dismissible => false;

  Duration duration(DateTime date) =>
      Duration(minutes: worklogs.fold(0, (p, c) => p + c.durata));

  bool get hasTimer => timer?.active ?? false;

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
    worklogs = new List<WorkLog>();
    if (json['worklogs'] != null) {
      json['worklogs'].forEach((v) {
        worklogs.add(new WorkLog.fromJson(v, task: this));
      });
    }
    serverTime = json['serverTime'];
    timer = json['timer'] != null ? new Timer.fromJson(json['timer']) : null;
    durata = json['durata'];
    dataModificaTask = json['lastModifiedDate'] ?? json['dataModificaTask'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }
}

class TaskResponse {
  List<Task> items;

  TaskResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Task>();
      json.forEach((v) {
        items.add(new Task.fromJson(v));
      });
    }
  }
}
