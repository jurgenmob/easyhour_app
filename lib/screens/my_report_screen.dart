import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/header.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

final _headerKey = GlobalKey<_MyReportHeaderState>();

class MyReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  DateTimeRange _currentMonthRange;
  DateTimeRange _previousMonthRange;

  @override
  void initState() {
    super.initState();

    // Define range for current and previous month
    final now = DateTime.now();
    _currentMonthRange = DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 0));
    _previousMonthRange = DateTimeRange(
        start: DateTime(now.year, now.month - 1, 1),
        end: DateTime(now.year, now.month, 0));

    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _MyReportHeader(key: _headerKey),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _MyReportScreenTab(_previousMonthRange,
                  nextArrowCallback: () => _tabController.animateTo(1)),
              _MyReportScreenTab(_currentMonthRange,
                  prevArrowCallback: () => _tabController.animateTo(0)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyReportScreenTab extends StatefulWidget {
  final DateTimeRange dateRange;
  final VoidCallback prevArrowCallback;
  final VoidCallback nextArrowCallback;

  _MyReportScreenTab(this.dateRange,
      {this.prevArrowCallback, this.nextArrowCallback});

  @override
  State<StatefulWidget> createState() => _MyReportScreenTabState();
}

class _MyReportScreenTabState extends State<_MyReportScreenTab> {
  List<CalendarEvent> _events;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    try {
      setState(() {
        _events = null;
      });

      // Get events
      final events = await EasyRest().getCalendarEvents(widget.dateRange);

      // Update header
      _headerKey.currentState
        ..dateRange = widget.dateRange
        ..events = events
        ..prevArrowCallback = widget.prevArrowCallback
        ..nextArrowCallback = widget.nextArrowCallback
        ..setState(() {});

      // Update list
      setState(() {
        _events = events;
      });
    } catch (e, s) {
      print(e);
      print(s);

      setState(() {
        _events = List();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _events != null
        ? _TaskList(
            CalendarProvider.workedHoursByType(widget.dateRange, _events))
        : EasyLoader();
  }
}

class _MyReportHeader extends StatefulWidget {
  _MyReportHeader({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyReportHeaderState();
}

class _MyReportHeaderState extends State<_MyReportHeader> {
  List<CalendarEvent> events;
  DateTimeRange dateRange;
  VoidCallback prevArrowCallback;
  VoidCallback nextArrowCallback;

  @override
  Widget build(BuildContext context) {
    if (dateRange == null) return Container();

    // Calculate target and worked hours
    final dateRangeToDate =
        CalendarProvider.monthRange(dateRange.mean, upToToday: true);
    final target = CalendarProvider.targetHours(dateRange);
    final targetToDate = CalendarProvider.targetHours(dateRangeToDate);
    final worked = CalendarProvider.workedHours(dateRange, events);
    final workedToDate = CalendarProvider.workedHours(dateRangeToDate, events);
    print("\nMy report (${dateRange.formatDisplay()}): " +
        "worked = ${worked.formatDisplay()}, target=${target.formatDisplay()}\n");
    print("\nMy report to date (${dateRangeToDate.formatDisplay()}): " +
        "worked = ${workedToDate.formatDisplay()}, target=${targetToDate.formatDisplay()}\n\n");

    // Set icons
    final targetIndicator =
        CalendarProvider.dayIndicator(worked: worked, target: target);
    final targetToDateIndicator = CalendarProvider.dayIndicator(
        worked: workedToDate, target: targetToDate);

    // Current month name
    final monthName = DateFormat('MMMM yyyy').format(dateRange.mean);

    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              prevArrowCallback != null
                  ? _button(context, EasyIcons.arrow_left, prevArrowCallback)
                  : SizedBox(width: 32),
              Expanded(
                child: EasyHeader(monthName.toUpperCase()),
              ),
              nextArrowCallback != null
                  ? _button(context, EasyIcons.arrow_right, nextArrowCallback)
                  : SizedBox(width: 32),
            ],
          ),
        ),
        SizedBox(height: 8),
        _row(context, LocaleKeys.label_month_hours.tr(),
            "${worked.formatDisplay()}\n${target.formatDisplay()}",
            icon: dateRange.end.isBefore(DateTime.now())
                ? targetIndicator.icon
                : null),
        _row(context, LocaleKeys.label_current_hours.tr(),
            "${workedToDate.formatDisplay()}\n${targetToDate.formatDisplay()}",
            icon: targetToDateIndicator.icon),
      ],
    );
  }

  Widget _button(BuildContext context, IconData icon, VoidCallback callback) =>
      InkWell(
        onTap: callback,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      );

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
      color: const Color(0xFF019CE4),
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
