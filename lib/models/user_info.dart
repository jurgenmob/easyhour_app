import 'package:easyhour_app/globals.dart';

import 'company.dart';

// https://javiercbk.github.io/json_to_dart/
class UserInfo {
  UserDTO userDTO;
  Company azienda;
  CompanyConfig configurazioneAzienda;
  UserExtra userExtra;
  DateTime serverTime;
  List<String> authorities;
  List<String> modulos;

  int dayOfTheWeek;

  bool get hasTimerModule =>
      configurazioneAzienda.modulos.contains(Module(id: activitiesModuleId));

  bool get hasSmartWorkingModule =>
      configurazioneAzienda.modulos.contains(Module(id: smartWorkingModuleId));

  bool get hasActivitiesModule =>
      configurazioneAzienda.modulos.contains(Module(id: activitiesModuleId));

  UserInfo.fromJson(Map<String, dynamic> json) {
    userDTO =
        json['userDTO'] != null ? new UserDTO.fromJson(json['userDTO']) : null;
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
    configurazioneAzienda = json['configurazioneAzienda'] != null
        ? new CompanyConfig.fromJson(json['configurazioneAzienda'])
        : null;
    userExtra = json['userExtra'] != null
        ? new UserExtra.fromJson(json['userExtra'])
        : null;
    serverTime = DateTime.parse(json['serverTime']);
    authorities = json['authorities'].cast<String>();
    modulos = json['modulos'].cast<String>();
    dayOfTheWeek = json['dayOfTheWeek'];
  }
}

class UserDTO {
  int id;
  String login;
  String firstName;
  String lastName;
  String email;
  String imageUrl;
  bool activated;
  String langKey;
  List<String> authorities;

  UserDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    activated = json['activated'];
    langKey = json['langKey'];
    authorities = json['authorities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['login'] = this.login;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['imageUrl'] = this.imageUrl;
    data['activated'] = this.activated;
    data['langKey'] = this.langKey;
    data['authorities'] = this.authorities;
    return data;
  }
}

class CompanyConfig {
  int id;
  String tipoAuth;
  int stepMinuti;
  String langKey;
  bool straordinari;

  List<Module> modulos;

  CompanyConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoAuth = json['tipoAuth'];
    stepMinuti = json['stepMinuti'];
    langKey = json['langKey'];
    straordinari = json['straordinari'];
    if (json['modulos'] != null) {
      modulos = new List<Module>();
      json['modulos'].forEach((v) {
        modulos.add(new Module.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['tipoAuth'] = this.tipoAuth;
    data['stepMinuti'] = this.stepMinuti;
    data['langKey'] = this.langKey;
    data['straordinari'] = this.straordinari;
    if (this.modulos != null) {
      data['modulos'] = this.modulos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Module {
  int id;
  String codice;
  String descrizione;

  Module({this.id, this.codice, this.descrizione});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codice = json['codice'];
    descrizione = json['descrizione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    data['codice'] = this.codice;
    data['descrizione'] = this.descrizione;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Module && runtimeType == other.runtimeType && id == other.id;

  @override
  get hashCode => id.hashCode;
}

class UserExtra {
  int id;
  String incarico;
  String reparto;
  bool manager;
  String tipoAuth;
  String dataNascita;
  String dataAssunzione;
  int tariffa;

  UserExtra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    incarico = json['incarico'];
    reparto = json['reparto'];
    manager = json['manager'];
    tipoAuth = json['tipoAuth'];
    dataNascita = json['dataNascita'];
    dataAssunzione = json['dataAssunzione'];
    tariffa = json['tariffa'];
  }
}

class UserInfoResponse {
  UserInfo info;

  UserInfoResponse.fromJson(Map<String, dynamic> json) {
    info = UserInfo.fromJson(json);
  }
}
