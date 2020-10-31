import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:flutter/material.dart';

import 'base_model.dart';

// https://javiercbk.github.io/json_to_dart/
abstract class Report with BaseModel {
  static fromTask(Task task, DurationAndCount durationAndCount) =>
      _ReportTask(task, durationAndCount: durationAndCount);

  static fromType(Type type, DurationAndCount durationAndCount) =>
      _ReportType(type, durationAndCount: durationAndCount);

  final Type type;
  final DurationAndCount durationAndCount;

  Report(this.type, {@required this.durationAndCount});

  @override
  get highlightDetailsTop => true;

  @override
  get editable => false;

  @override
  get dismissible => false;

  @override
  provider(BuildContext context) => null;
}

class _ReportTask extends Report {
  final Task task;

  _ReportTask(this.task, {@required DurationAndCount durationAndCount})
      : super(null, durationAndCount: durationAndCount);

  @override
  int get id => task.id;

  @override
  get listTitle => task.nomeTask;

  @override
  get listSuptitle => task.nomeCliente;

  @override
  get listSubtitle => task.nomeProgetto;

  @override
  get listDetailsTop => durationAndCount.duration.formatDisplay();

  @override
  get listDetailsBtm =>
      durationAndCount.average.formatDisplay() +
      "\n" +
      LocaleKeys.label_on_average.tr();
}

class _ReportType extends Report {
  _ReportType(type, {@required DurationAndCount durationAndCount})
      : super(type, durationAndCount: durationAndCount);

  @override
  int get id => type.hashCode;

  @override
  get listTitle => BaseModel.displayName(type).plural(2).toUpperCase();

  @override
  get listDetailsTop {
    switch (type) {
      case Trip:
        return LocaleKeys.label_days.plural(durationAndCount.count);
      case Activity:
        return "${durationAndCount.count} " +
            LocaleKeys.label_activities
                .plural(durationAndCount.count)
                .toLowerCase();
      default:
        return durationAndCount.duration.formatDisplay();
    }
  }

  @override
  get listDetailsBtm {
    switch (type) {
      case Vacation:
      case Permit:
      case Sickness:
        return LocaleKeys.label_on_days.plural(durationAndCount.count);
      default:
        return null;
    }
  }
}
