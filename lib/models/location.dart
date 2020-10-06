import 'package:easyhour_app/models/company.dart';
import 'package:easyhour_app/models/user.dart';

class Location {
  int id;
  String descrizione;
  String nome;
  double lat;
  double lnt;
  bool attivo;
  User user;
  Company azienda;

  Location(
      {this.id,
      this.descrizione,
      this.nome,
      this.lat,
      this.lnt,
      this.attivo,
      this.user,
      this.azienda});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
    nome = json['nome'];
    lat = json['lat'];
    lnt = json['lnt'];
    attivo = json['attivo'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null && id > 0) {
      // Existing location
      data['id'] = this.id;
    } else {
      // New location
      data['nome'] = this.nome;
      data['lat'] = this.lat;
      data['lnt'] = this.lnt;
    }

    return data;
  }

  @override
  String toString() {
    return 'Location{id: $id, nome: $nome, lat: $lat, lnt: $lnt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          id != null &&
          id == other.id ||
      other is Location &&
          runtimeType == other.runtimeType &&
          nome != null &&
          nome == other.nome;

  @override
  int get hashCode => id.hashCode;
}

class LocationResponse {
  List<Location> items;

  LocationResponse({this.items});

  LocationResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Location>();
      json.forEach((v) {
        items.add(new Location.fromJson(v));
      });
    }
  }
}
