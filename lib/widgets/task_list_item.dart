import 'package:easyhour_app/models/task.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final CrossAxisAlignment alignment;

  const TaskListItem(this.task, {Key key, this.alignment}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "task-${task.id}",
      child: Column(
          crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
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
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(task.nomeProgetto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white)),
          ]),
    );
  }
}
