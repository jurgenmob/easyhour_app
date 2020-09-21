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
    data['id'] = this.id;

    return data;
  }
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
