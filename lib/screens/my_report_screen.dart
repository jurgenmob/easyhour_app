import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/calendar.dart';
import 'package:easyhour_app/models/report.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/header.dart';
import 'package:easyhour_app/widgets/header_content.dart';
import 'package:easyhour_app/widgets/list_item.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

final _headerKey = GlobalKey<_MyReportHeaderState>();
final _currentMonthTabKey = GlobalKey<_MyReportScreenTabState>();
final _previousMonthTabKey = GlobalKey<_MyReportScreenTabState>();

class MyReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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

  Future _refreshCurrentTab() async {
    if (_tabController.index == 0) {
      // Update tab content
      final events = await EasyRest().getCalendarEvents(_previousMonthRange);
      _previousMonthTabKey.currentState._events = events;
      _previousMonthTabKey.currentState.setState(() {});

      // Update header
      _headerKey.currentState
        ..dateRange = _previousMonthRange
        ..events = events
        ..setState(() {});
    } else if (_tabController.index == 1) {
      // Update tab content
      final events = await EasyRest().getCalendarEvents(_currentMonthRange);
      _currentMonthTabKey.currentState._events = events;
      _currentMonthTabKey.currentState.setState(() {});

      // Update header
      _headerKey.currentState
        ..dateRange = _currentMonthRange
        ..events = events
        ..setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FixedHeaderAndContent(
      header: _MyReportHeader(key: _headerKey),
      content: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _MyReportScreenTab(
              key: _previousMonthTabKey,
              dateRange: _previousMonthRange,
              nextArrowCallback: () => _tabController.animateTo(1)),
          _MyReportScreenTab(
              key: _currentMonthTabKey,
              dateRange: _currentMonthRange,
              prevArrowCallback: () => _tabController.animateTo(0)),
        ],
      ),
      onRefresh: _refreshCurrentTab,
    );
  }

  @override
  get wantKeepAlive => true;
}

class _MyReportScreenTab extends StatefulWidget {
  final DateTimeRange dateRange;
  final VoidCallback prevArrowCallback;
  final VoidCallback nextArrowCallback;

  _MyReportScreenTab(
      {Key key,
      @required this.dateRange,
      this.prevArrowCallback,
      this.nextArrowCallback})
      : super(key: key);

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
  DateTimeRange _dateRangeToDate;
  VoidCallback prevArrowCallback;
  VoidCallback nextArrowCallback;

  @override
  Widget build(BuildContext context) {
    if (dateRange == null) return Container();

    // Calculate target and worked hours
    _dateRangeToDate =
        CalendarProvider.monthRange(dateRange.mean, upToToday: true);
    final target = CalendarProvider.targetHours(dateRange);
    final targetToDate = CalendarProvider.targetHours(_dateRangeToDate);
    final worked = CalendarProvider.workedHours(dateRange, events);
    final workedToDate = CalendarProvider.workedHours(_dateRangeToDate, events);
    print("\nMy report (${dateRange.formatDisplay()}): " +
        "worked = ${worked.formatDisplay()}, target=${target.formatDisplay()}\n");
    print("\nMy report to date (${_dateRangeToDate.formatDisplay()}): " +
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
        _row(
            context,
            LocaleKeys.label_month_hours.tr() +
                (kDebugMode ? " [" + dateRange.formatDisplay() + "]" : ""),
            "${worked.formatDisplay()}\n${target.formatDisplay()}",
            icon: dateRange.end.isBefore(DateTime.now())
                ? targetIndicator.icon
                : null),
        _row(
            context,
            LocaleKeys.label_current_hours.tr() +
                (kDebugMode
                    ? " [" + _dateRangeToDate.formatDisplay() + "]"
                    : ""),
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
              child: Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.normal)),
            ),
          ),
          if (icon != null) icon,
          SizedBox(width: 16),
          Text(value,
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.normal)),
          SizedBox(width: 16)
        ],
      );
}

class _TaskList extends StatelessWidget {
  final Map<dynamic, DurationAndCount> _items;

  _TaskList(this._items);

  @override
  Widget build(BuildContext context) {
    final keys = _items.keys.toList();

    return keys?.isNotEmpty == true
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (_, index) => getItem(keys[index]))
        : EmptyList(text: LocaleKeys.empty_list_report.tr());
  }

  Widget getItem(dynamic key) =>
      _ReportItem(key, durationAndCount: _items[key]);
}

class _ReportItem extends StatelessWidget {
  final dynamic typeOrTask;
  final DurationAndCount durationAndCount;

  _ReportItem(this.typeOrTask, {@required this.durationAndCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: EasyListItem<Report>(typeOrTask is Task
          ? Report.fromTask(typeOrTask, durationAndCount)
          : Report.fromType(typeOrTask, durationAndCount)),
    );
  }
}
