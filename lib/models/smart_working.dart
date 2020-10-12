import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'company.dart';
import 'user.dart';

// https://javiercbk.github.io/json_to_dart/
class SmartWorking with BaseModel {
  int id;
  String descrizione;
  DateTime dataInizio;
  DateTime dataFine;
  String stato;
  User user;
  Location location;
  Company azienda;

  SmartWorking(
      {this.id,
      this.descrizione,
      this.dataInizio,
      this.dataFine,
      this.stato,
      this.user,
      this.location,
      this.azienda});

  @override
  get listTitle => LocaleKeys.label_smartworkings.plural(1).toUpperCase();

  @override
  get listSubtitle => location?.nome;

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
  SmartWorkingProvider provider(BuildContext context) =>
      context.read<SmartWorkingProvider>();

  SmartWorking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    dataInizio = DateTime.parse(json['dataInizio']);
    dataFine = DateTime.parse(json['dataFine']);
    stato = json['stato'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['dataInizio'] = this.dataInizio.formatRest();
    data['dataFine'] = this.dataFine.formatRest();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class SmartWorkingResponse {
  List<SmartWorking> items;

  SmartWorkingResponse({this.items});

  SmartWorkingResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<SmartWorking>();
      json.forEach((v) {
        items.add(new SmartWorking.fromJson(v));
      });
    }
  }
}
