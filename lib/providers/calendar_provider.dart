import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/calendar.dart';

import 'base_provider.dart';

class CalendarProvider extends BaseProvider<CalendarEvent> {
  @override
  // Do nothing, calendar provider requires a date interval
  Future<List<CalendarEvent>> get() => Future.value(List());

  void getEvents(DateTime startDate, DateTime endDate) async {
    super.restGet(EasyRest().getCalendarEvents(startDate, endDate));
  }

  void _addEvent(
      Map<DateTime, List<BaseModel>> events, DateTime date, BaseModel event) {
    events.putIfAbsent(date, () => List<BaseModel>());
    events[date].add(event);
  }

  void _addEventRange(Map<DateTime, List<BaseModel>> events, DateTime startDate,
      DateTime endDate, BaseModel event) {
    final daysToGenerate = endDate.difference(startDate).inDays + 1;
    final days = List.generate(daysToGenerate,
        (i) => DateTime(startDate.year, startDate.month, startDate.day + (i)));

    days.forEach((date) {
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
}
