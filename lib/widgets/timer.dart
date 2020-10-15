import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:flutter/material.dart';

typedef ContextCallback = void Function(BuildContext);

mixin TimerCoordinator {
  onStart();

  onStop();

  bool confirmStart(BuildContext context);
}

/// The timer icon along with the associated start/stop feature
class EasyTimer extends StatefulWidget {
  final Task task;
  final ContextCallback onEdit;
  final TimerCoordinator coordinator;

  EasyTimer(this.task, {@required this.coordinator, @required this.onEdit});

  @override
  State<StatefulWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<EasyTimer> {
  bool _loading = false;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    // Start the timer if active
    if (task.hasTimer && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startLocalTimer());
    }

    final text = task.hasTimer || _timer != null
        ? task.timer.duration.formatDisplay(showSeconds: true)
        : Duration(minutes: task.duration).formatDisplay(showZero: false);

    return _loading
        ? Container(width: 100, child: EasyLoader(color: Colors.white54))
        : InkWell(
            onTap: () =>
                widget.onEdit != null ? widget.onEdit(context) : _toggleTimer(),
            child: Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      task.hasTimer ? EasyIcons.timer_on : EasyIcons.timer_off,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    if (text != null)
                      Text(text,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.white,
                              fontWeight: task.duration > 0 ||
                                      task.hasTimer ||
                                      _timer != null
                                  ? FontWeight.bold
                                  : FontWeight.normal))
                  ],
                )),
          );
  }

  void _toggleTimer() async {
    if (_timer == null) {
      if (widget.coordinator?.confirmStart(context) ?? true) _startTimer();
    } else {
      final result =
          await showConfirmDialog(context, LocaleKeys.message_stop_timer.tr());
      if (result) _stopTimer();
    }
  }

  void _startTimer() async {
    try {
      setState(() {
        _loading = true;
      });

      // Let the server know we're starting a new timer
      widget.task.timer = await EasyRest().startTimer(widget.task,
          widget.task.worklogs.isNotEmpty ? widget.task.worklogs.first : null);

      // Start the timer locally
      _startLocalTimer();
    } catch (e, s) {
      handleRestError(context, e, s);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _startLocalTimer() {
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(() {}),
    );

    widget.coordinator?.onStart();
  }

  void _stopTimer() async {
    try {
      setState(() {
        _loading = true;
      });

      // Let the server know we're starting a new timer
      widget.task.timer = await EasyRest().stopTimer(widget.task.timer);

      // Start the timer locally
      _stopLocalTimer();

      // Create the worklog
      const i = worklogMinuteInterval;
      widget.task.timer.worklog
        ..durata = widget.task.duration +
            (widget.task.timer.duration.inMinutes / i).round() * i
        ..task = widget.task;
      final result = await Navigator.pushNamed(
          context, (EasyRoute.addEdit(Worklog)?.page),
          arguments: widget.task.timer.worklog);

      // Show the result message
      if (result != null) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e, s) {
      handleRestError(context, e, s);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _stopLocalTimer() {
    _timer?.cancel();
    _timer = null;

    widget.coordinator?.onStop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
