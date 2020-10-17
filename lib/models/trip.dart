import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'client.dart';
import 'company.dart';
import 'user.dart';

// https://javiercbk.github.io/json_to_dart/
class Trip with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  DateTime dataInizio;
  DateTime dataFine;
  Company azienda;
  User user;
  Client cliente;

  Trip(
      {this.id,
      this.descrizione,
      this.dataInizio,
      this.dataFine,
      this.azienda,
      this.user,
      this.cliente});

  @override
  get listTitle => LocaleKeys.label_trips.plural(1).toUpperCase();

  @override
  get listSubtitle => cliente?.nome ?? "";

  @override
  get listDetailsTop => dataInizio.formatDisplay();

  @override
  get listDetailsBtm => dataFine.formatDisplay();

  @override
  get dateRange => dataInizio != null && dataFine != null
      ? DateTimeRange(start: dataInizio, end: dataFine)
      : null;

  @override
  Duration duration(DateTime date) => Duration();

  @override
  TripProvider provider(BuildContext context) => context.read<TripProvider>();

  @override
  String toString() {
    return 'Trip{id: $id, dataInizio: $dataInizio, dataFine: $dataFine, cliente: $cliente}';
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    dataInizio = DateTime.parse(json['dataInizio']);
    dataFine = DateTime.parse(json['dataFine']);
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    cliente =
        json['cliente'] != null ? new Client.fromJson(json['cliente']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['dataInizio'] = this.dataInizio.formatRest();
    data['dataFine'] = this.dataFine.formatRest();
    if (this.cliente != null) {
      data['cliente'] = this.cliente.toJson();
    }
    return data;
  }
}

class TripResponse {
  List<Trip> items;

  TripResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Trip>();
      json.forEach((v) {
        items.add(new Trip.fromJson(v));
      });
    }
  }
}
