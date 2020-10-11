import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'base_model.dart';
import 'company.dart';
import 'user.dart';

// https://javiercbk.github.io/json_to_dart/
class Activity with BaseModel, CalendarEvent {
  int id;
  String descrizione;
  String tipologia;
  DateTime data;
  String oraInizio;
  String oraFine;
  User user;
  Company azienda;

  Activity(
      {this.id,
      this.descrizione,
      this.tipologia,
      this.data,
      this.oraInizio,
      this.oraFine,
      this.user,
      this.azienda});

  @override
  String get listTitle => LocaleKeys.label_activities.plural(1);

  @override
  String get listSubtitle => tipologia;

  @override
  String get listDetailsTop => data.formatDisplay();

  @override
  String get listDetailsBtm => "$oraInizio - $oraFine";

  @override
  DateTimeRange get dateRange => data != null ? dateRangeFromDate(data) : null;

  @override
  ActivityProvider provider(BuildContext context) =>
      Provider.of<ActivityProvider>(context, listen: false);

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    tipologia = json['tipologia'];
    data = DateTime.parse(json['data']);
    oraInizio = json['oraInizio'];
    oraFine = json['oraFine'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['descrizione'] = this.descrizione;
    data['tipologia'] = this.tipologia;
    data['data'] = this.data;
    data['oraInizio'] = this.oraInizio;
    data['oraFine'] = this.oraFine;
    return data;
  }
}

class ActivityResponse {
  List<Activity> items;

  ActivityResponse({this.items});

  ActivityResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Activity>();
      json.forEach((v) {
        items.add(new Activity.fromJson(v));
      });
    }
  }
}
