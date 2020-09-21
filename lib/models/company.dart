class Company {
  int id;
  String name;
  String domain;
  bool activated;

  Company({this.id, this.name, this.domain, this.activated});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    domain = json['domain'];
    activated = json['activated'];
  }
}
