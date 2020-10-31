import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/theme.dart';
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

  static List<DateTime> _expand(DateTimeRange range) => List.generate(
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

    allItems.where((e) => e.runtimeType != Holiday)?.forEach((e) {
      _addEventRange(events, e.dateRange.start, e.dateRange.end, e);
    });

    return events;
  }

  /// Holidays in Map format (to be used to feed the calendar)
  Map<DateTime, List> get holidays {
    Map<DateTime, List<BaseModel>> holidays = {};

    allItems.where((e) => e.runtimeType == Holiday)?.forEach((e) {
      _addEvent(holidays, e.dateRange.start, e);
    });

    return holidays;
  }

  void addEditWorklog(WorkLog worklog) {
    delete(worklog);
    add(worklog);

    notifyListeners();
  }

  /// Get the whole range of a month, ending today if needed
  static DateTimeRange monthRange(DateTime date, {bool upToToday = false}) {
    final today = DateTime.now();
    final startDate = DateTime(date.year, date.month, 1);
    final endDate = DateTime(date.year, date.month + 1, 0);

    return DateTimeRange(
        start: startDate,
        end: upToToday && today.isAfter(startDate) && endDate.isAfter(today)
            ? today
            : endDate);
  }

  /// Get the ok/ko indicator to be shown on calendar icon
  static Future<CalendarIndicator> monthIndicator(
      {DateTimeRange dateRange}) async {
    if (dateRange == null) {
      // Get events of current month
      dateRange = monthRange(DateTime.now(), upToToday: true);
    } else if (dateRange.start.isAfter(DateTime.now())) {
      // Don't show indicator for future months
      return Future.value(dayIndicator(worked: null, target: null));
    }
    final events = await EasyRest().getCalendarEvents(dateRange);

    // Calculate target and worked hours
    Duration target = targetHours(dateRange);
    Duration worked = workedHours(dateRange, events);
    print("\nMonth indicator (${dateRange.formatDisplay()}): " +
        "worked = ${worked.formatDisplay()}, target=${target.formatDisplay()}\n\n");

    return Future.value(dayIndicator(worked: worked, target: target));
  }

  /// Get target hours for a given time range
  static Duration targetHours(DateTimeRange dateRange) {
    if (userInfo == null) return Duration.zero;

    Duration target = Duration();
    _expand(dateRange).forEach((date) {
      target += userInfo.targetHours(date);

      // if (kDebugMode)
      //   print("Indicator: target for ${date.formatDisplay()} = " +
      //       "${userInfo.targetHours(date).formatDisplay()}\n");
    });

    return target;
  }

  /// Get worked hours for a given time range
  static Duration workedHours(
      DateTimeRange dateRange, List<CalendarEvent> events) {
    Duration worked = Duration();
    events.forEach((event) {
      _expand(event.dateRange).forEach((date) {
        if (dateRange.contains(date)) {
          worked += event.duration(date);

          // if (kDebugMode)
          //   print("Indicator: worked for ${date.formatDisplay()} = " +
          //       "${event.duration(date).formatDisplay()}\n");
        }
      });
    });

    return worked;
  }

  /// Get worked hours for a given time range, aggregated by task/vacation/permit/etc.
  static Map<dynamic, DurationAndCount> workedHoursByType(
      DateTimeRange dateRange, List<CalendarEvent> events) {
    Map<dynamic, DurationAndCount> map = {};
    events.forEach((event) {
      _expand(event.dateRange).forEach((date) {
        if (dateRange.contains(date)) {
          // For worklogs use tasks
          final key = event is WorkLog ? event.task : event.runtimeType;
          map.putIfAbsent(key, () => DurationAndCount());
          map[key] += event.duration(date);
        }
      });
    });

    return map;
  }

  // Calendar indicator colors
  static CalendarIndicator dayIndicator(
          {@required Duration worked, @required Duration target}) =>
      worked == null || target == null
          ? null
          : worked == target
              ? const CalendarIndicator("",
                  foreground: Colors.black, background: EasyColors.calOk)
              : (worked < target
                  ? CalendarIndicator(
                      (worked.inHours - target.inHours).formatWithSign(),
                      foreground: Colors.white,
                      background: EasyColors.calMissing)
                  : CalendarIndicator(
                      (worked.inHours - target.inHours).formatWithSign(),
                      foreground: Colors.black,
                      background: EasyColors.calTooMuch));
}

class CalendarIndicator {
  final Color foreground;
  final Color background;
  final String text;

  Icon get icon => Icon(
      background == EasyColors.calOk
          ? EasyIcons.approve_ok
          : EasyIcons.approve_ko,
      color: background);

  const CalendarIndicator(this.text,
      {@required this.foreground, this.background = Colors.transparent});

  const CalendarIndicator.transparent()
      : this("", foreground: Colors.transparent);
}
