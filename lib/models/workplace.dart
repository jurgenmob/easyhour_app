import 'office.dart';

class WorkPlace {
  int id;
  String nome;
  Office ufficio;

  WorkPlace({this.id, this.nome, this.ufficio});

  @override
  WorkPlace.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    ufficio =
        json['ufficio'] != null ? new Office.fromJson(json['ufficio']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['nome'] = this.nome;
    data['ufficio'] = this.ufficio.toJson();
    return data;
  }

  @override
  String toString() {
    return 'WorkPlace{id: $id, name: $nome, office: $ufficio}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkPlace && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class WorkPlaceResponse {
  List<WorkPlace> items;

  WorkPlaceResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<WorkPlace>();
      json.forEach((v) {
        items.add(new WorkPlace.fromJson(v));
      });
    }
  }
}
