import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/providers/task_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../generated/locale_keys.g.dart';

final _calendarKey = GlobalKey<_CalendarWidgetState>();

class CalendarScreen extends BaseScreen {
  @override
  Widget getBody() => CalendarWidget(key: _calendarKey);

  @override
  List<EasyRoute> getAppBarRoutes(context) => [
        EasyRoute.calendar(
            callback: () => _calendarKey.currentState._calendarController
                .setSelectedDay(DateTime.now())),
        EasyRoute.addEdit(WorkLog,
            arguments: () =>
                WorkLog(data: _calendarKey.currentState._selectedDay))
      ];
}

class CalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();

  CalendarWidget({Key key}) : super(key: key);
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  Map<DateTime, List> _holidays;
  CalendarProvider _provider;
  DateTime _selectedDay = DateTime.now();

  // List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _provider = context.read<CalendarProvider>();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _provider.filter = DateTime.now());

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    _selectedDay = day;
    _provider.filter = day;
    setState(() {});
  }

  void _refreshEvents(
      DateTime first, DateTime last, CalendarFormat format) async {
    final eventsRange = DateTimeRange(start: first, end: last);
    _provider.getEvents(eventsRange);

    // Update calendar indicator with current month
    DateTimeRange indicatorRange;
    if (!eventsRange.contains(DateTime.now())) {
      // Select month of currently visible range
      final mean = DateTime.fromMillisecondsSinceEpoch(
          (first.millisecondsSinceEpoch + last.millisecondsSinceEpoch) ~/ 2);
      indicatorRange = DateTimeRange(
          start: DateTime(mean.year, mean.month, 1),
          end: DateTime(mean.year, mean.month + 1, 0));
    }
    EasyAppBar.updateCalendarIndicator(context, dateRange: indicatorRange);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
        builder: (_, CalendarProvider model, Widget child) {
      // Get events and holidays
      _events = model.events;
      _holidays = model.holidays;

      // Add all days to show the worked hours count of each day
      try {
        _calendarController.visibleDays.forEach((e) {
          if (userInfo.targetHours(e).inMinutes > 0 &&
              !_holidays.containsKey(e))
            _events.putIfAbsent(e, () => List<BaseModel>());
        });
      } catch (e) {}

      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            const SizedBox(height: 8.0),
            Expanded(child: _EventList()),
          ],
        ),
      );
    });
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TableCalendar(
        calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.monday,
        events: _events,
        holidays: _holidays,
        onDaySelected: _onDaySelected,
        onVisibleDaysChanged: _refreshEvents,
        onCalendarCreated: (first, last, format) => {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _refreshEvents(first, last, format))
        },
        calendarStyle: CalendarStyle(
          selectedColor: Colors.white,
          todayColor: Colors.transparent,
          todayStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          selectedStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
          weekdayStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          weekendStyle: const TextStyle(color: const Color(0xFFCCCCCC)),
          holidayStyle: const TextStyle(color: const Color(0XFFECE43E)),
          unavailableStyle: const TextStyle(color: const Color(0xFFCCCCCC)),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          centerHeaderTitle: true,
          titleTextStyle: Theme.of(context).textTheme.button,
          leftChevronIcon:
              const Icon(EasyIcons.arrow_left, color: Colors.white, size: 16),
          rightChevronIcon:
              const Icon(EasyIcons.arrow_right, color: Colors.white, size: 16),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: const TextStyle(color: Colors.white),
          weekendStyle: const TextStyle(color: Colors.white),
        ),
        builders: CalendarBuilders(
            markersBuilder: (context, date, events, holidays) => [
                  _buildEventsMarker(date, events),
                ]),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    // print("\n\n_buildEventsMarker() called with date = $date, events = $events");

    // Calculate worked hours
    final workedHours =
        events.fold<Duration>(Duration(), (p, e) => p + e.duration(date));

    // Calculate target hours
    final targetHours = userInfo.targetHours(date);

    // Calculate text and colors:
    // - if the date is in the past use the indicator
    // - if the date is the selected day show worked hours + indicator
    // - if the date is in the future don't show anything
    final today = DateTime.now();
    final text = date.isSameDay(_selectedDay) ? "${workedHours.inHours}" : "";
    final CalendarIndicator indicator = date.isSameDay(_selectedDay)
        ? ((date.isSameDay(today) || date.isBefore(today))
            ? CalendarProvider.dayIndicator(
                worked: workedHours, target: targetHours)
            : const CalendarIndicator("",
                foreground: Colors.black, background: Colors.white))
        : date.isAfter(today)
            ? CalendarIndicator.transparent()
            : CalendarProvider.dayIndicator(
                worked: workedHours, target: targetHours);
    final double size = text?.isNotEmpty == true ? 16 : 8;
    final double position = text?.isNotEmpty == true ? 1 : 8;

    return Positioned(
        right: position,
        bottom: position,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: indicator.background,
          ),
          width: size,
          height: size,
          child: Center(
            child: Text(
              text,
              style: TextStyle().copyWith(
                color: indicator.foreground,
                fontSize: 12,
              ),
            ),
          ),
        ));
  }
}

class _EventList extends StatefulWidget {
  @override
  createState() => _EventListState();
}

class _EventListState
    extends EasyListState<_EventList, BaseModel, CalendarProvider> {
  _EventListState() : super(LocaleKeys.empty_list_calendar.tr());

  @override
  void onDelete(BaseModel item) {
    // Delete the item from its own provider
    if (item is WorkLog) {
      // Due to server constraints worklogs need a special treatment
      context.read<TaskProvider>().deleteWorklog(context, item.task, item);
    } else {
      item.provider(context).delete(item);
    }

    // Also delete the item from calendar
    context.read<CalendarProvider>().delete(item);
  }
}
