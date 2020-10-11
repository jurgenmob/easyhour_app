import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'company.dart';
import 'user.dart';

class Permit with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  DateTime data;
  String oraInizio;
  String oraFine;
  String stato;
  User user;
  Company azienda;

  Permit(
      {this.id,
      this.descrizione,
      this.data,
      this.oraInizio,
      this.oraFine,
      this.stato,
      this.user,
      this.azienda});

  @override
  String get listTitle => LocaleKeys.label_permits.plural(1).toUpperCase();

  @override
  String get listDetailsTop => data.formatDisplay();

  @override
  String get listDetailsBtm => "$oraInizio - $oraFine";

  @override
  bool get approved => stato == approvedValue;

  @override
  bool get editable => false;

  @override
  DateTimeRange get dateRange => data != null ? dateRangeFromDate(data) : null;

  @override
  PermitProvider provider(BuildContext context) =>
      Provider.of<PermitProvider>(context, listen: false);

  Permit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    data = DateTime.parse(json['data']);
    oraInizio = json['oraInizio'];
    oraFine = json['oraFine'];
    stato = json['stato'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['data'] = this.data.formatRest();
    data['oraInizio'] = this.oraInizio;
    data['oraFine'] = this.oraFine;
    return data;
  }
}

class PermitResponse {
  List<Permit> items;

  PermitResponse({this.items});

  PermitResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Permit>();
      json.forEach((v) {
        items.add(new Permit.fromJson(v));
      });
    }
  }
}
