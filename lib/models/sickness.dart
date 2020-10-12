import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'calendar.dart';
import 'company.dart';
import 'today_activity.dart';
import 'user.dart';

class Sickness with BaseModel, TodayActivity, CalendarEvent {
  int id;
  String descrizione;
  DateTime dataInizio;
  DateTime dataFine;
  User user;
  Company azienda;

  Sickness(
      {this.id,
      this.descrizione,
      this.dataInizio,
      this.dataFine,
      this.user,
      this.azienda});

  @override
  String get listTitle => LocaleKeys.label_sicknesses.plural(1).toUpperCase();

  @override
  String get listDetailsTop => dataInizio.formatDisplay();

  @override
  String get listDetailsBtm => dataFine.formatDisplay();

  @override
  DateTimeRange get dateRange => dataInizio != null && dataFine != null
      ? DateTimeRange(start: dataInizio, end: dataFine)
      : null;

  @override
  SicknessProvider provider(BuildContext context) =>
      context.read<SicknessProvider>();

  Sickness.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    dataInizio = DateTime.parse(json['dataInizio']);
    dataFine = DateTime.parse(json['dataFine']);
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
}

class SicknessResponse {
  List<Sickness> items;

  SicknessResponse({this.items});

  SicknessResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Sickness>();
      json.forEach((v) {
        items.add(new Sickness.fromJson(v));
      });
    }
  }
}
