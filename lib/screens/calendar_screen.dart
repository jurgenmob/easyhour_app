import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/calendar_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../generated/locale_keys.g.dart';

class CalendarScreen extends BaseScreen {
  @override
  Widget getBody() => CalendarWidget();

  @override
  EasyAppBarAction getEasyAppBarAction() => null;
}

class CalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  Map<DateTime, List> _holidays;
  CalendarProvider _provider;

  // List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<CalendarProvider>(context, listen: false);

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

  void _onDaySelected(DateTime day, List events) {
    _provider.filter = day;
    setState(() {});
  }

  void _refreshEvents(DateTime first, DateTime last, CalendarFormat format) {
    _provider.getEvents(first, last);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
        builder: (_, CalendarProvider model, Widget child) {
      _events = model.events;
      _holidays = model.holidays;

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
          markersColor: const Color(0xFFCCCCCC),
          selectedStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
          weekdayStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          weekendStyle: const TextStyle(color: const Color(0xFFCCCCCC)),
          holidayStyle: const TextStyle(color: const Color(0XFFECE43E)),
          unavailableStyle: const TextStyle(color: const Color(0xFFCCCCCC)),
          markersMaxAmount: 1,
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
      ),
    );
  }
}

class _EventList extends StatefulWidget {
  @override
  createState() => _EventListState();
}

class _EventListState extends EasyListState<BaseModel, CalendarProvider> {
  _EventListState() : super(LocaleKeys.empty_list_calendar.tr());

  @override
  void onDelete(BaseModel item) {
    // Delete the item from its own provider
    if (item is Worklog) {
      // Due to server constraints worklogs need a special treatment
      final provider =
          Provider.of<TodayActivitiesProvider>(context, listen: false);
      provider.deleteWorklog(/*provider.getTask(item)*/ null, item);
    } else {
      item.provider(context).delete(item);
    }

    // Also delete the item from calendar
    Provider.of<CalendarProvider>(context, listen: false).delete(item);
  }
}
