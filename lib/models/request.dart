import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/user.dart';
import 'package:easyhour_app/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Request with BaseModel {
  int id;
  String tipologia;
  User utente;
  DateTime dataInizio;
  DateTime dataFine;
  String oraInizio;
  String oraFine;
  String stato;
  String descrizione;
  int countAllegati;
  Location location;
  bool deleted;

  Request(
      {this.id,
      this.tipologia,
      this.utente,
      this.dataInizio,
      this.dataFine,
      this.oraInizio,
      this.oraFine,
      this.stato,
      this.descrizione,
      this.countAllegati,
      this.location,
      this.deleted});

  @override
  get listTitle => tipologia;

  @override
  get listSubtitle =>
      utente.fullName + (descrizione?.isNotEmpty == true ? " *" : "");

  @override
  get listDetailsTop => dataInizio.formatDisplay();

  @override
  get listDetailsBtm => dataFine?.formatDisplay() ?? "$oraInizio - $oraFine";

  @override
  get editable => true; // allow showing description on tap

  @override
  get dateRange => dataFine != null
      ? DateTimeRange(start: dataInizio, end: dataFine)
      : dateRangeFromDate(dataInizio);

  @override
  RequestProvider provider(BuildContext context) =>
      context.read<RequestProvider>();

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipologia = json['tipologia'];
    utente = json['utente'] != null ? new User.fromJson(json['utente']) : null;
    if (json['data_inizio'] != null) {
      dataInizio = DateTime.parse(json['data_inizio']);
    }
    if (json['data_fine'] != null) {
      dataFine = DateTime.parse(json['data_fine']);
    }
    oraInizio = json['ora_inizio'];
    oraFine = json['ora_fine'];
    stato = json['stato'];
    descrizione = json['descrizione'];
    countAllegati = json['countAllegati'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    deleted = json['deleted'];
  }
}

class RequestResponse {
  List<Request> items;

  RequestResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Request>();
      json.forEach((v) {
        items.add(new Request.fromJson(v));
      });
    }
  }
}
