import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/office_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Office with BaseModel {
  int id;
  String nome;
  String descrizione;
  String prefisso;
  int quantita;
  int postazioniCount;

  Office({this.id, this.nome, this.descrizione, this.prefisso, this.quantita});

  @override
  get listTitle => LocaleKeys.label_offices.plural(1).toUpperCase();

  @override
  get listSubtitle => nome;

  @override
  get listDetailsTop => "$quantita ${LocaleKeys.label_workplaces_short.tr()}";

  @override
  get editable => false;

  @override
  Office.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descrizione = json['descrizione'];
    prefisso = json['prefisso'];
    quantita = json['quantita'] ?? 0;
    postazioniCount = json['postazioniCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['nome'] = this.nome;
    data['descrizione'] = this.descrizione;
    data['prefisso'] = this.prefisso;
    if (quantita != null) {
      data['quantita'] = this.quantita;
    }
    if (postazioniCount != null) {
      data['postazioniCount'] = this.postazioniCount;
    }
    return data;
  }

  @override
  String toString() {
    return 'Office{id: $id, name: $nome}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Office && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  OfficeProvider provider(BuildContext context) =>
      context.read<OfficeProvider>();
}

class OfficeResponse {
  List<Office> items;

  OfficeResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Office>();
      json.forEach((v) {
        items.add(new Office.fromJson(v));
      });
    }
  }
}
