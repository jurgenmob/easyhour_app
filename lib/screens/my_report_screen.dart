import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/header.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  DateTimeRange _dateRange;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Get events for current month
      final date = DateTime.now();
      _dateRange = DateTimeRange(
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1, 0));
      context.read<CalendarProvider>()
        ..filter = null
        ..getEvents(_dateRange);

      // Update the calendar icon
      EasyAppBar.updateCalendarIndicator(context);
    });

    return Consumer<CalendarProvider>(
        builder: (_, CalendarProvider model, Widget child) {
      return _dateRange != null
          ? Column(children: [
              _MyReportHeader(model.items, _dateRange),
              Expanded(
                  child: _TaskList(CalendarProvider.workedHoursByType(
                      _dateRange, model.items)))
            ])
          : EasyLoader();
    });
  }
}

class _MyReportHeader extends StatelessWidget {
  final List<CalendarEvent> _items;
  final DateTimeRange _dateRange;

  _MyReportHeader(this._items, this._dateRange);

  @override
  Widget build(BuildContext context) {
    // Calculate target and worked houts
    final dateRangeToDate =
        CalendarProvider.monthRange(_dateRange.mean, upToToday: true);
    final target = CalendarProvider.targetHours(_dateRange);
    final targetToDate = CalendarProvider.targetHours(dateRangeToDate);
    final worked = CalendarProvider.workedHours(_dateRange, _items);
    final workedToDate = CalendarProvider.workedHours(dateRangeToDate, _items);
    print("\nMy report (${_dateRange.formatDisplay()}): " +
        "worked = ${worked.formatDisplay()}, target=${target.formatDisplay()}\n");
    print("\nMy report to date (${dateRangeToDate.formatDisplay()}): " +
        "worked = ${workedToDate.formatDisplay()}, target=${targetToDate.formatDisplay()}\n\n");

    // Set icons
    final targetIndicator =
        CalendarProvider.dayIndicator(worked: worked, target: target);
    final targetToDateIndicator = CalendarProvider.dayIndicator(
        worked: workedToDate, target: targetToDate);

    // Current month name
    final monthName = DateFormat('MMMM yyyy').format(_dateRange.mean);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: EasyHeader(monthName.toUpperCase()),
            ),
          ],
        ),
        SizedBox(height: 8),
        _row(context, LocaleKeys.label_month_hours.tr(),
            "${worked.formatDisplay()}\n${target.formatDisplay()}",
            icon: _dateRange.end.isBefore(DateTime.now())
                ? targetIndicator.icon
                : null),
        _row(context, LocaleKeys.label_current_hours.tr(),
            "${workedToDate.formatDisplay()}\n${targetToDate.formatDisplay()}",
            icon: targetToDateIndicator.icon),
      ],
    );
  }

  Widget _row(BuildContext context, String text, String value, {Widget icon}) =>
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(text, style: Theme.of(context).textTheme.bodyText1),
            ),
          ),
          if (icon != null) icon,
          SizedBox(
              width: 108,
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1))
        ],
      );
}

class _TaskList extends StatelessWidget {
  final Map<dynamic, Duration> _items;
  final Duration _totalDuration;

  _TaskList(this._items)
      : _totalDuration = _items.values.fold(Duration.zero, (p, e) => p + e);

  @override
  Widget build(BuildContext context) {
    final keys = _items.keys.toList();

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: keys.length,
        itemBuilder: (_, index) => getItem(keys[index]));
  }

  Widget getItem(dynamic key) =>
      _ReportItem(key, duration: _items[key], totalDuration: _totalDuration);
}

class _ReportItem extends StatelessWidget {
  final dynamic type;
  final Duration duration;
  final Duration totalDuration;

  _ReportItem(this.type,
      {@required this.duration, @required this.totalDuration});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF019CE4),
      margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: Theme.of(context).primaryColor,
              child: type is Task
                  ? TaskListItem(type, heroTag: "myreport-${type.id}")
                  : Container(
                      height: 80,
                      alignment: Alignment.centerLeft,
                      child: Text(BaseModel.displayName(type).plural(2),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
            ),
          ),
          Container(
              width: 100,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(duration.formatDisplay(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  // SizedBox(
                  //   width: 60,
                  //   height: 60,
                  //   child: CircularProgressIndicator(
                  //       value: duration.inSeconds / totalDuration.inSeconds,
                  //       backgroundColor: Theme.of(context).primaryColor,
                  //       valueColor:
                  //           AlwaysStoppedAnimation<Color>(Colors.white)),
                  // )
                ],
              ))
        ],
      ),
    );
  }
}
