import 'package:easyhour_app/globals.dart';

import 'company.dart';

// https://javiercbk.github.io/json_to_dart/
class UserInfo {
  UserDTO userDTO;
  Company azienda;
  CompanyConfig configurazioneAzienda;
  UserExtra userExtra;
  DateTime serverTime;
  int dayOfTheWeek;
  List<String> authorities;
  List<String> modulos;
  List<WorkShift> turniAzienda;
  List<WorkShift> turniUser;
  WorkShift turnoOggi;

  bool get hasTimerModule =>
      configurazioneAzienda.modulos.contains(Module(id: activitiesModuleId));

  bool get hasSmartWorkingModule =>
      configurazioneAzienda.modulos.contains(Module(id: smartWorkingModuleId));

  bool get hasActivitiesModule =>
      configurazioneAzienda.modulos.contains(Module(id: activitiesModuleId));

  bool get isReporter =>
      authorities?.contains(roleReporter) ?? false || isAdmin;

  bool get isAdmin => authorities?.contains(roleAdmin) ?? false;

  bool get isManager => isAdmin || userExtra?.manager == true;

  /// Returns the working hours of the user (if any) or the company (if any) or defaults
  List<WorkShift> get workShifts => turniUser?.isNotEmpty == true
      ? turniUser
      : turniAzienda?.isNotEmpty == true
          ? turniAzienda
          : WorkShift.defaultWorkShifts();

  /// Returns the target hours for a given day
  Duration targetHours(DateTime date) => workShifts
      .firstWhere((w) => w.giorno == date.weekday,
          orElse: () => WorkShift.fromDefaults(date.weekday))
      .duration;

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
    if (json['turniAzienda'] != null) {
      turniAzienda = new List<WorkShift>();
      json['turniAzienda'].forEach((v) {
        turniAzienda.add(new WorkShift.fromJson(v));
      });
    }
    if (json['turniUser'] != null) {
      turniUser = new List<Null>();
      json['turniUser'].forEach((v) {
        turniUser.add(new WorkShift.fromJson(v));
      });
    }
    turnoOggi = json['turnoOggi'] != null
        ? new WorkShift.fromJson(json['turnoOggi'])
        : null;
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

class WorkShift {
  int id;
  int giorno;
  String t1Inizio;
  String t1Fine;
  String t2Inizio;
  String t2Fine;
  String t3Inizio;
  String t3Fine;
  String t4Inizio;
  String t4Fine;
  bool lavorativo;

  WorkShift(
      {this.id,
      this.giorno,
      this.t1Inizio,
      this.t1Fine,
      this.t2Inizio,
      this.t2Fine,
      this.t3Inizio,
      this.t3Fine,
      this.t4Inizio,
      this.t4Fine,
      this.lavorativo});

  WorkShift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    giorno = json['giorno'];
    t1Inizio = json['t1Inizio'];
    t1Fine = json['t1Fine'];
    t2Inizio = json['t2Inizio'];
    t2Fine = json['t2Fine'];
    t3Inizio = json['t3Inizio'];
    t3Fine = json['t3Fine'];
    t4Inizio = json['t4Inizio'];
    t4Fine = json['t4Fine'];
    lavorativo = json['lavorativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['giorno'] = this.giorno;
    data['t1Inizio'] = this.t1Inizio;
    data['t1Fine'] = this.t1Fine;
    data['t2Inizio'] = this.t2Inizio;
    data['t2Fine'] = this.t2Fine;
    data['t3Inizio'] = this.t3Inizio;
    data['t3Fine'] = this.t3Fine;
    data['t4Inizio'] = this.t4Inizio;
    data['t4Fine'] = this.t4Fine;
    data['lavorativo'] = this.lavorativo;
    return data;
  }

  WorkShift.fromDefaults(int day, {bool workingDay}) {
    if (workingDay == null)
      workingDay = day != DateTime.saturday && day != DateTime.sunday;

    id = day;
    giorno = day;
    lavorativo = workingDay;
    t1Inizio = workingDay ? "9:00" : "";
    t1Fine = workingDay ? "13:00" : "";
    t2Inizio = workingDay ? "14:00" : "";
    t2Fine = workingDay ? "18:00" : "";
    t3Inizio = null;
    t3Fine = null;
    t4Inizio = null;
    t4Fine = null;
  }

  // The duration of this work shift
  Duration get duration => lavorativo
      ? Duration(
          minutes: [
          [t1Inizio, t1Fine],
          [t2Inizio, t2Fine],
          [t3Inizio, t3Fine],
          [t4Inizio, t4Fine]
        ].fold<int>(
              0,
              (prev, shift) => shift[0] != null && shift[1] != null
                  ? prev +
                      shift[1].asTimeOfDay().inMinutes -
                      shift[0].asTimeOfDay().inMinutes
                  : prev))
      : Duration();

  static defaultWorkShifts() {
    return [
      WorkShift.fromDefaults(DateTime.monday, workingDay: true),
      WorkShift.fromDefaults(DateTime.tuesday, workingDay: true),
      WorkShift.fromDefaults(DateTime.wednesday, workingDay: true),
      WorkShift.fromDefaults(DateTime.thursday, workingDay: true),
      WorkShift.fromDefaults(DateTime.friday, workingDay: true),
      WorkShift.fromDefaults(DateTime.saturday, workingDay: false),
      WorkShift.fromDefaults(DateTime.sunday, workingDay: false),
    ];
  }
}

class UserInfoResponse {
  UserInfo info;

  UserInfoResponse.fromJson(Map<String, dynamic> json) {
    info = UserInfo.fromJson(json);
  }
}
