import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/workplace.dart';
import 'package:easyhour_app/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'base_model.dart';

// https://javiercbk.github.io/json_to_dart/
class Booking with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  DateTime dataInizio;
  DateTime dataFine;
  WorkPlace postazione;

  Booking(
      {this.id,
      this.descrizione,
      this.dataInizio,
      this.dataFine,
      this.postazione});

  @override
  get listTitle => LocaleKeys.label_bookings.plural(1).toUpperCase();

  @override
  get listSubtitle => postazione != null
      ? "${postazione.nome} (${postazione.ufficio?.nome})"
      : null;

  @override
  get listDetailsTop => dataInizio.formatDisplay();

  @override
  get listDetailsBtm => dataFine.formatDisplay();

  @override
  get editable => false;

  @override
  get dateRange => dataInizio != null && dataFine != null
      ? DateTimeRange(start: dataInizio, end: dataFine)
      : null;

  String formatDisplay() => postazione != null
      ? "${postazione.nome} (${postazione.ufficio.nome})"
      : null;

  @override
  Duration duration(DateTime date) => Duration();

  @override
  BookingProvider provider(BuildContext context) =>
      context.read<BookingProvider>();

  @override
  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    dataInizio = DateTime.parse(json['dataInizio']);
    dataFine = DateTime.parse(json['dataFine']);
    postazione = WorkPlace.fromJson(json['postazione']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['dataInizio'] = this.dataInizio.formatRest();
    data['dataFine'] = this.dataFine.formatRest();
    data['postazione'] = this.postazione.toJson();

    return data;
  }

  @override
  String toString() {
    return 'WorkPlace{id: $id, dataInizio: $dataInizio, dataFine: $dataFine}';
  }
}

class BookingResponse {
  List<Booking> items;

  BookingResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Booking>();
      json.forEach((v) {
        items.add(new Booking.fromJson(v));
      });
    }
  }
}
