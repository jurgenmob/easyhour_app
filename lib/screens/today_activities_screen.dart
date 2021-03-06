import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:easyhour_app/widgets/search_bar.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:easyhour_app/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TodayActivitiesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodayActivitiesScreenState();
}

class _TodayActivitiesScreenState extends State<TodayActivitiesScreen> {
  DateTime today;

  @override
  void initState() {
    super.initState();

    today = DateTime.now();

    // Reload state when date changes
    Future.delayed(
            DateTime(today.year, today.month, today.day + 1).difference(today))
        .then((_) => setState(() => today = DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    // Update the calendar icon
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => EasyAppBar.updateCalendarIndicator(context));

    return Consumer<TodayActivitiesProvider>(
        key: ValueKey(today),
        builder: (_, TodayActivitiesProvider model, Widget child) {
          final Type type = model.items?.isNotEmpty ?? false
              ? model.items.first.runtimeType
              : null;

          return type == Vacation || type == Sickness
              ? Column(children: [
                  SizedBox(height: 24),
                  _TodayActivitiesHeader(model.items,
                      today: today, showTotalDuration: false),
                  SizedBox(height: 8),
                  Expanded(child: _VacationSicknessContainer(type))
                ])
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(children: [
                    EasySearchBar<TodayActivitiesProvider>(),
                    _TodayActivitiesHeader(model.items,
                        today: today, showTotalDuration: true),
                    SizedBox(height: 8),
                    Expanded(child: _TaskList(today))
                  ]),
                );
        });
  }
}

class _TodayActivitiesHeader extends StatelessWidget {
  final DateTime today;
  final List<TodayActivity> items;
  final bool showTotalDuration;

  _TodayActivitiesHeader(this.items,
      {@required this.today, this.showTotalDuration = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(DateFormat("dd MMMM yyyy").format(today),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2),
          ),
        ),
        if (showTotalDuration)
          Container(
              width: 108,
              child: Text(_totalDuration().formatDisplay(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2)),
      ],
    );
  }

  Duration _totalDuration() =>
      items.fold<Duration>(Duration(), (p, c) => p + c.duration(today));
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
  final DateTime today;

  @override
  createState() => _TaskListState();

  _TaskList(this.today) : super(key: _taskListKey);
}

class _TaskListState
    extends EasyListState<_TaskList, TodayActivity, TodayActivitiesProvider>
    with TimerCoordinator {
  bool _timerActive = false;

  _TaskListState() : super(emptyText: LocaleKeys.empty_list_tasks.tr());

  String get _flaggedTaskPrefKey => "${userInfo?.prefKey}flaggedTasks";

  List<String> get _flaggedTasks =>
      prefs.getStringList(_flaggedTaskPrefKey) ?? List();

  bool isFlagged(Task task) => _flaggedTasks.contains(task.id.toString());

  void toggleFlagged(Task task) {
    final _flaggedTasks = this._flaggedTasks;
    if (isFlagged(task)) {
      _flaggedTasks.remove(task.id.toString());
    } else {
      _flaggedTasks.add(task.id.toString());
    }
    prefs.setStringList(_flaggedTaskPrefKey, _flaggedTasks);
  }

  @override
  Widget getItem(int index, TodayActivity item) {
    return _TaskItem(widget, item as Task);
  }

  @override
  Comparator comparator() => (a, b) => isFlagged(a) && isFlagged(b)
      ? 0
      : isFlagged(a)
          ? 1
          : isFlagged(b)
              ? -1
              : 0;

  @override
  bool confirmStart(BuildContext context) {
    if (_timerActive) {
      showMessage(Scaffold.of(context), LocaleKeys.message_timer_active.tr());
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
    final bool flagged = _taskListKey.currentState.isFlagged(widget.task);

    return Dismissible(
      key: ValueKey("${widget.task.id}-$flagged"),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        // Toggle the flagged state
        _taskListKey.currentState.toggleFlagged(widget.task);
        setState(() {}); // set semi-transparent
        _taskListKey.currentState.setState(() {}); // update sorting
        return Future.value(false);
      },
      dismissThresholds: {DismissDirection.startToEnd: 0.2},
      background: Container(
          color: const Color(0xFFAAAAAA),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  flagged
                      ? Icons.vertical_align_top
                      : Icons.vertical_align_bottom,
                  color: Colors.white),
              SizedBox(height: 4),
              Text(
                  flagged
                      ? LocaleKeys.label_unflag_task.tr()
                      : LocaleKeys.label_flag_task.tr(),
                  textAlign: TextAlign.center,
                  style: snackBarStyle)
            ],
          )),
      child: Opacity(
        opacity: flagged ? 0.5 : 1.0,
        child: Card(
          color: const Color(0xFF019CE4),
          margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
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
        : WorkLog(data: widget.list.today, task: widget.task);
    final result = await EasyAppBar.pushNamed(
        context, EasyRoute.addEdit(WorkLog, arguments: () => worklog));

    // Show the result message
    if (result != null) showMessage(Scaffold.of(context), result);
  }
}
