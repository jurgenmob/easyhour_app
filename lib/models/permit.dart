import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/providers/permit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  get listTitle => LocaleKeys.label_permits.plural(1).toUpperCase();

  @override
  get listSubtitle => descrizione;

  @override
  get listDetailsTop => data.formatDisplay();

  @override
  get listDetailsBtm => "$oraInizio - $oraFine";

  @override
  get approvedIcon => defaultApprovedIcon(stato);

  @override
  get editable => false;

  @override
  get dateRange => data != null ? dateRangeFromDate(data) : null;

  @override
  Duration duration(DateTime date) => Duration(
      minutes:
          oraFine.asTimeOfDay().inMinutes - oraInizio.asTimeOfDay().inMinutes);

  @override
  PermitProvider provider(BuildContext context) =>
      context.read<PermitProvider>();

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

  PermitResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Permit>();
      json.forEach((v) {
        items.add(new Permit.fromJson(v));
      });
    }
  }
}
