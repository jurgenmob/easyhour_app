import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'calendar.dart';
import 'client.dart';
import 'user.dart';

class Worklog with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  DateTime data;
  int durata;
  User user;
  WorklogTask task;
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
  String get listTitle => task.nome;

  @override
  String get listSuptitle => task.progetto?.cliente?.nome;

  @override
  String get listSubtitle => task.progetto?.nome;

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
  DateTimeRange get dateRange =>
      data != null ? DateTimeRange(start: data, end: data) : null;

  @override
  Provider provider(BuildContext context) => null;

  @override
  String toString() {
    return 'Worklog{data: $data, durata: $durata, task: $task}';
  }

  Worklog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    data = DateTime.parse(json['data']);
    durata = json['durata'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    task = json['task'] != null ? new WorklogTask.fromJson(json['task']) : null;
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

class WorklogTask {
  int id;
  String nome;
  String descrizione;
  double tariffa;
  String createdDate;
  String createdBy;
  String lastModifiedDate;
  String lastModifiedBy;
  int stimaDurata;
  bool attivo;
  Progetto progetto;
  List<String> fases;

  WorklogTask(
      {this.id,
      this.nome,
      this.descrizione,
      this.tariffa,
      this.createdDate,
      this.createdBy,
      this.lastModifiedDate,
      this.lastModifiedBy,
      this.stimaDurata,
      this.attivo,
      this.progetto,
      this.fases});

  WorklogTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descrizione = json['descrizione'];
    tariffa = json['tariffa'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    lastModifiedDate = json['lastModifiedDate'];
    lastModifiedBy = json['lastModifiedBy'];
    stimaDurata = json['stimaDurata'];
    attivo = json['attivo'];
    progetto = json['progetto'] != null
        ? new Progetto.fromJson(json['progetto'])
        : null;
    if (json['fases'] != null) {
      fases = new List<String>();
      json['fases'].forEach((v) {
        fases.add(v);
      });
    }
  }

  WorklogTask.fromTask(Task task) {
    id = task.id;
    nome = task.nomeTask;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }
}

class Progetto {
  int id;
  String nome;
  String codice;
  String descrizione;
  String contatto;
  int tariffa;
  bool fatturabile;
  bool attivo;
  bool descrizioneObbligatoria;
  String createdDate;
  String createdBy;
  String lastModifiedDate;
  String lastModifiedBy;
  Client cliente;
  String projectManager;

  Progetto(
      {this.id,
      this.nome,
      this.codice,
      this.descrizione,
      this.contatto,
      this.tariffa,
      this.fatturabile,
      this.attivo,
      this.descrizioneObbligatoria,
      this.createdDate,
      this.createdBy,
      this.lastModifiedDate,
      this.lastModifiedBy,
      this.cliente,
      this.projectManager});

  Progetto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    codice = json['codice'];
    descrizione = json['descrizione'];
    contatto = json['contatto'];
    tariffa = json['tariffa'];
    fatturabile = json['fatturabile'];
    attivo = json['attivo'];
    descrizioneObbligatoria = json['descrizioneObbligatoria'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    lastModifiedDate = json['lastModifiedDate'];
    lastModifiedBy = json['lastModifiedBy'];
    cliente =
        json['cliente'] != null ? new Client.fromJson(json['cliente']) : null;
    projectManager = json['projectManager'];
  }
}
