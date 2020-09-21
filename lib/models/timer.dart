import 'company.dart';
import 'worklog.dart';

class Timer {
  int id;
  String startTime;
  String endTime;
  bool registrato;
  Worklog worklog;
  Company azienda;

  Timer(
      {this.id,
      this.startTime,
      this.endTime,
      this.registrato,
      this.worklog,
      this.azienda});

  Timer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    registrato = json['registrato'];
    if (json['worklog'] != null) {
      worklog = Worklog.fromJson(json['worklog']);
    }
    if (json['azienda'] != null) {
      azienda = Company.fromJson(json['azienda']);
    }
  }
}
