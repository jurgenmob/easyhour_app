import 'package:flutter/material.dart';

mixin BaseModel<T, P> {
  int get id;

  bool get isNew => id == null || id == 0;

  String get listTitle;

  String get listSubtitle => null;

  String get listSuptitle => null;

  String get listDetailsTop => null;

  String get listDetailsBtm => null;

  bool get approved => null;

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
