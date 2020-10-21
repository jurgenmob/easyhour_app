import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/models/permit.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/models/workplace.dart';
import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';

mixin BaseModel<T, P> {
  int get id;

  bool get isNew => id == null || id == 0;

  String get listTitle;

  String get listSubtitle => null;

  String get listSuptitle => null;

  String get listDetailsTop => null;

  String get listDetailsBtm => null;

  IconData get approvedIcon => null;

  @protected
  IconData defaultApprovedIcon(String state) => state == approvedValue
      ? EasyIcons.approve_ok
      : state == refusedValue
          ? EasyIcons.approve_ko
          : EasyIcons.approve_pending;

  DateTimeRange get dateRange => null;

  @protected
  DateTimeRange dateRangeFromDate(DateTime date) => DateTimeRange(
      start: DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0),
      end: DateTime(date.year, date.month, date.day, 23, 59, 59, 0, 0));

  /// True if the element can be deleted by the user
  bool get dismissible => true;

  /// True if the element can be edited by the user
  bool get editable => true;

  bool filter(dynamic filter) =>
      (id?.toString() ?? "").contains(filter.toString());

  P provider(BuildContext context);

  static String displayName(Type t) {
    if (t == Vacation)
      return LocaleKeys.label_vacations;
    else if (t == Permit)
      return LocaleKeys.label_permits;
    else if (t == Sickness)
      return LocaleKeys.label_sicknesses;
    else if (t == Trip)
      return LocaleKeys.label_trips;
    else if (t == Activity)
      return LocaleKeys.label_activities;
    else if (t == SmartWorking)
      return LocaleKeys.label_smartworkings;
    else if (t == WorkLog)
      return LocaleKeys.label_worklogs;
    else if (t == Location)
      return LocaleKeys.label_locations;
    else if (t == Booking)
      return LocaleKeys.label_bookings;
    else if (t == WorkPlace)
      return LocaleKeys.label_workplaces;
    else if (t == Office)
      return LocaleKeys.label_offices;
    else
      return "";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

extension ContainsIgnoreCase on String {
  bool containsIgnoreCase(String other) {
    return this.toLowerCase().contains(other);
  }
}
