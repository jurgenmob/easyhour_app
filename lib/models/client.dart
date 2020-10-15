class Client {
  int id;
  String nome;
  String codice;
  String descrizione;
  bool attivo;

  @override
  String toString() {
    return 'Cliente{id: $id, nome: $nome}';
  }

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    codice = json['codice'];
    descrizione = json['descrizione'];
    attivo = json['attivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }
}

class ClientResponse {
  List<Client> items;

  ClientResponse.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Client>();
      json.forEach((v) {
        items.add(new Client.fromJson(v));
      });
    }
  }
}
