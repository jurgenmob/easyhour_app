import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/duration_picker.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:easyhour_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';

class TodayScreen extends StatelessWidget {
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
        Text(DateFormat("dd MMMM yyyy").format(DateTime.now()),
            style: Theme.of(context).textTheme.bodyText2),
        SizedBox(height: 8),
        Expanded(
            child: type == Vacation || type == Sickness
                ? _VacationSicknessContainer(type)
                : _TaskList())
      ]);
    });
  }
}

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
    extends EasyListState<TodayActivity, TodayActivitiesProvider> {
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
    final duration = Duration(minutes: task.duration)?.formatDisplay();

    return Card(
      color: Color(0xFF019CE4),
      margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: InkWell(
        onTap: () => _showDurationPicker(context),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Theme.of(context).primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(task.nomeCliente,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(task.nomeTask.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.white)),
                    Text(task.nomeProgetto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white)),
                  ],
                ),
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
                    if (duration != null) SizedBox(height: 8),
                    if (duration != null)
                      Text(duration,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context) async {
    final TextStyle buttonStyle = Theme.of(context)
        .textTheme
        .button
        .copyWith(color: Theme.of(context).primaryColor);
    Widget cancelButton = FlatButton(
      child: Text(LocaleKeys.label_cancel.tr(), style: buttonStyle),
      onPressed: () => Navigator.of(context).pop(false),
    );
    Widget okButton = FlatButton(
      child: Text(LocaleKeys.label_ok.tr(), style: buttonStyle),
      onPressed: () => Navigator.of(context).pop(true),
    );

    final picker = EasyDurationPicker(Duration(minutes: task.duration));

    var result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Column(
                children: [
                  Expanded(child: picker),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [cancelButton, okButton])
                ],
              ));
        });

    if (result ?? false) {
      final duration = picker.value.inMinutes;

      // Set the duration in the worklog (add if needed)
      Worklog worklog = task.worklogs?.isEmpty ?? true
          ? Worklog(data: DateTime.now(), task: WorklogTask.fromTask(task))
          : task.worklogs.first;
      worklog.durata = duration;

      final provider =
          Provider.of<TodayActivitiesProvider>(context, listen: false);
      try {
        if (duration == 0) {
          // Delete worklog
          if (!worklog.isNew) await provider.deleteWorklog(task, worklog);
        } else {
          // Add/edit worklog
          await provider.addEditWorklog(task, worklog);
        }
      } catch (e, s) {
        handleRestError(context, e, s);
      }
    }
  }
}
