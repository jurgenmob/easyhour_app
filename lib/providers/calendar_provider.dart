import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base_provider.dart';

class CalendarProvider extends BaseProvider<CalendarEvent> {
  @override
  // Do nothing, calendar provider requires a date interval
  Future<List<CalendarEvent>> get() => Future.value(List());

  void getEvents(DateTimeRange dateRange) async {
    super.restGet(EasyRest().getCalendarEvents(dateRange));
  }

  List<DateTime> _expand(DateTimeRange range) => List.generate(
      range.end.difference(range.start).inDays + 1,
      (i) =>
          DateTime(range.start.year, range.start.month, range.start.day + (i)));

  void _addEvent(
      Map<DateTime, List<BaseModel>> events, DateTime date, BaseModel event) {
    events.putIfAbsent(date, () => List<BaseModel>());
    events[date].add(event);
  }

  void _addEventRange(Map<DateTime, List<BaseModel>> events, DateTime startDate,
      DateTime endDate, BaseModel event) {
    _expand(DateTimeRange(start: startDate, end: endDate)).forEach((date) {
      _addEvent(events, date, event);
    });
  }

  /// All events in Map format (to be used to feed the calendar)
  Map<DateTime, List> get events {
    Map<DateTime, List<BaseModel>> events = {};

    allItems.where((e) => e.runtimeType != Holiday).forEach((e) {
      _addEventRange(events, e.dateRange.start, e.dateRange.end, e);
    });

    return events;
  }

  /// Holidays in Map format (to be used to feed the calendar)
  Map<DateTime, List> get holidays {
    Map<DateTime, List<BaseModel>> holidays = {};

    allItems.where((e) => e.runtimeType == Holiday).forEach((e) {
      _addEvent(holidays, e.dateRange.start, e);
    });

    return holidays;
  }

  void addEditWorklog(WorkLog worklog) {
    delete(worklog);
    add(worklog);

    notifyListeners();
  }

  Future<Color> monthIndicator({DateTimeRange dateRange}) async {
    if (dateRange == null) {
      // Get events of current month
      DateTime now = DateTime.now();
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0);
      dateRange = DateTimeRange(
          start: startDate, end: endDate.isAfter(now) ? now : endDate);
    }
    final events = await EasyRest().getCalendarEvents(dateRange);

    // Calculate target hours
    Duration target = Duration();
    _expand(dateRange).forEach((date) {
      target += userInfo.targetHours(date);

      if (kDebugMode)
        print("Month indicator: target for ${date.formatDisplay()} = " +
            "${userInfo.targetHours(date).formatDisplay()}\n");
    });

    // Calculate worked hours
    Duration worked = Duration();
    events.forEach((event) {
      _expand(event.dateRange).forEach((date) {
        if (dateRange.contains(date)) {
          worked += event.duration(date);

          if (kDebugMode)
            print("Month indicator: worked for ${date.formatDisplay()} = " +
                "${event.duration(date).formatDisplay()}\n");
        }
      });
    });
    print("\nMonth indicator (${dateRange.formatDisplay()}): " +
        "worked = ${worked.formatDisplay()}, target=${target.formatDisplay()}\n\n");

    return Future.value(dayIndicator(worked: worked, target: target));
  }

  // Calendar indicator colors
  static Color dayIndicator(
          {@required Duration worked, @required Duration target}) =>
      worked == target
          ? Colors.greenAccent
          : (worked < target ? Colors.red : Colors.yellow);
}
