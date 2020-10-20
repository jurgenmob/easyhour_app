import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:easyhour_app/widgets/search_bar.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:easyhour_app/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';

class TodayActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Update the calendar icon
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => EasyAppBar.updateCalendarIndicator(context));

    return Consumer<TodayActivitiesProvider>(
        builder: (_, TodayActivitiesProvider model, Widget child) {
      final Type type = model.items?.isNotEmpty ?? false
          ? model.items.first.runtimeType
          : null;

      return Column(children: [
        type == Vacation || type == Sickness
            ? SizedBox(height: 24)
            : EasySearchBar<TodayActivitiesProvider>(),
        _TodayActivitiesHeader(model.items),
        SizedBox(height: 8),
        Expanded(
            child: type == Vacation || type == Sickness
                ? _VacationSicknessContainer(type)
                : _TaskList())
      ]);
    });
  }
}

class _TodayActivitiesHeader extends StatelessWidget {
  final List<TodayActivity> _items;

  _TodayActivitiesHeader(this._items);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(DateFormat("dd MMMM yyyy").format(DateTime.now()),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2),
          ),
        ),
        Container(
            width: 108,
            child: Text(_totalDuration().formatDisplay(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2)),
      ],
    );
  }

  Duration _totalDuration() =>
      _items.fold<Duration>(Duration(), (p, c) => p + c.duration(null));
}

/// Shown when the user is not at work
class _VacationSicknessContainer extends StatelessWidget {
  final Type _type;

  _VacationSicknessContainer(this._type);

  @override
  Widget build(BuildContext context) {
    String image, text1, text2;
    if (_type == Vacation) {
      image = 'images/vacation.png';
      text1 = LocaleKeys.message_happy_holidays.tr();
      text2 = LocaleKeys.message_send_postcard.tr();
    } else if (_type == Sickness) {
      image = 'images/sickness.png';
      text1 = LocaleKeys.message_get_well_soon.tr();
      text2 = LocaleKeys.message_missing_you.tr();
    }

    return Container(
        margin: EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(const Radius.circular(15)),
            boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black)]),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15)),
              child: Image.asset(image),
            ),
            Spacer(),
            Text(text1,
                style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(text2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black)),
            Spacer(),
          ],
        ));
  }
}

final _taskListKey = GlobalKey<_TaskListState>();

class _TaskList extends StatefulWidget {
  static final _flaggedTaskPrefKey = 'flaggedTasks';

  final List<String> _flaggedTasks;

  @override
  createState() => _TaskListState();

  bool isFlagged(Task task) => _flaggedTasks.contains(task.id.toString());

  void toggleFlagged(Task task) {
    if (isFlagged(task)) {
      _flaggedTasks.remove(task.id.toString());
    } else {
      _flaggedTasks.add(task.id.toString());
    }
    prefs.setStringList(_flaggedTaskPrefKey, _flaggedTasks);
  }

  _TaskList()
      : _flaggedTasks = prefs.getStringList(_flaggedTaskPrefKey) ?? List(),
        super(key: _taskListKey);
}

class _TaskListState
    extends EasyListState<_TaskList, TodayActivity, TodayActivitiesProvider>
    with TimerCoordinator {
  bool _timerActive = false;

  @override
  Widget getItem(TodayActivity item) {
    return _TaskItem(widget, item as Task);
  }

  @override
  Comparator comparator() =>
      (a, b) => widget.isFlagged(a) && widget.isFlagged(b)
          ? 0
          : widget.isFlagged(a)
              ? 1
              : widget.isFlagged(b)
                  ? -1
                  : 0;

  @override
  bool confirmStart(BuildContext context) {
    if (_timerActive) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(LocaleKeys.message_timer_active.tr())));
      return false;
    }
    return true;
  }

  @override
  onStart() => _timerActive = true;

  @override
  onStop() => _timerActive = false;
}

class _TaskItem extends StatefulWidget {
  final Task task;
  final _TaskList list;

  _TaskItem(this.list, this.task);

  @override
  State<StatefulWidget> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey("${widget.task.id}-${widget.list.isFlagged(widget.task)}"),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        // Toggle the flagged state
        widget.list.toggleFlagged(widget.task);
        setState(() {}); // set semi-transparent
        _taskListKey.currentState.setState(() {}); // update sorting
        return Future.value(false);
      },
      dismissThresholds: {DismissDirection.startToEnd: 0.2},
      child: Opacity(
        opacity: widget.list.isFlagged(widget.task) ? 0.5 : 1.0,
        child: Card(
          color: Color(0xFF019CE4),
          margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
          child: InkWell(
            onTap: () {
              _onEdit(context);
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Theme.of(context).primaryColor,
                    child: TaskListItem(widget.task,
                        heroTag: "task-${widget.task.id}"),
                  ),
                ),
                EasyTimer(widget.task,
                    onEdit: userInfo.hasTimerModule ? null : _onEdit,
                    coordinator: _taskListKey.currentState)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onEdit(BuildContext context) async {
    // Worklog cannot be null, even when creating a new one, because a
    // reference to the task is always needed
    final worklog = widget.task.worklogs.length > 0
        ? widget.task.worklogs.first
        : WorkLog(data: DateTime.now(), task: widget.task);
    final result = await Navigator.pushNamed(
        context, (EasyRoute.addEdit(WorkLog)?.page),
        arguments: worklog);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }

    // Restore the appbar icon
    context.read<EasyAppBarProvider>().actions = [EasyRoute.calendar()];
    EasyAppBar.updateCalendarIndicator(context);
  }
}
