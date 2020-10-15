import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'company.dart';
import 'today_activity.dart';
import 'user.dart';

// https://javiercbk.github.io/json_to_dart/
class Vacation with BaseModel, TodayActivity, CalendarEvent {
  int id;
  String descrizione;
  DateTime dataInizio;
  DateTime dataFine;
  String stato;
  User user;
  Company azienda;

  Vacation(
      {this.id,
      this.descrizione,
      this.dataInizio,
      this.dataFine,
      this.stato,
      this.user,
      this.azienda});

  @override
  get listTitle => LocaleKeys.label_vacations.plural(1).toUpperCase();

  @override
  get listSubtitle => descrizione;

  @override
  get listDetailsTop => dataInizio.formatDisplay();

  @override
  get listDetailsBtm => dataFine.formatDisplay();

  @override
  get approved => stato == approvedValue;

  @override
  get editable => false;

  @override
  get dateRange => dataInizio != null && dataFine != null
      ? DateTimeRange(start: dataInizio, end: dataFine)
      : null;

  @override
  VacationProvider provider(BuildContext context) =>
      context.read<VacationProvider>();

  @override
  Vacation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    dataInizio = DateTime.parse(json['dataInizio']);
    dataFine = DateTime.parse(json['dataFine']);
    stato = json['stato'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['dataInizio'] = this.dataInizio.formatRest();
    data['dataFine'] = this.dataFine.formatRest();
    return data;
  }

  @override
  String toString() {
    return 'Vacation{id: $id, dataInizio: $dataInizio, dataFine: $dataFine, stato: $stato}';
  }
}

class VacationResponse {
  List<Vacation> items;

  VacationResponse({this.items});

  VacationResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Vacation>();
      json.forEach((v) {
        items.add(new Vacation.fromJson(v));
      });
    }
  }
}
