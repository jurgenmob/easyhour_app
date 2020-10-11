import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:easyhour_app/widgets/search_bar.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';

class TodayActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  final List<TodayActivity> items;

  _TodayActivitiesHeader(this.items);

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
      Duration(minutes: items.fold<int>(0, (p, c) => p + c.duration));
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

class _TaskList extends StatefulWidget {
  @override
  createState() => _TaskListState();
}

class _TaskListState
    extends EasyListState<_TaskList, TodayActivity, TodayActivitiesProvider> {
  _TaskListState() : super(LocaleKeys.empty_list_tasks.tr());

  @override
  StatelessWidget getItem(TodayActivity item) {
    return _TaskItem(item as Task);
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;

  const _TaskItem(this.task, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = Duration(minutes: task.duration).formatDisplay();

    return Card(
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
                child: TaskListItem(task),
              ),
            ),
            Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      EasyIcons.timer_off,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(duration,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white,
                            fontWeight: task.duration > 0
                                ? FontWeight.bold
                                : FontWeight.normal))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _onEdit(BuildContext context) async {
    // Worklog cannot be null, even when creating a new one, because a
    // reference to the task is always needed
    final worklog = task.worklogs.length > 0
        ? task.worklogs.first
        : Worklog(data: DateTime.now(), task: task);
    final result = await Navigator.pushNamed(
        context, (EasyRoute.addEdit(Worklog)?.page),
        arguments: worklog);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }

    // Restore the appbar icon
    Provider.of<EasyAppBarProvider>(context, listen: false).action =
        EasyRoute.calendar();
  }
}
