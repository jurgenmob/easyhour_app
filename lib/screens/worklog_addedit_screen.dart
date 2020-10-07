import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/today_activity.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorklogAddEditScreen extends BaseAddEditScreen<Worklog> {
  @override
  Widget getBody() => _WorklogForm();
}

class _WorklogForm extends StatefulWidget {
  @override
  createState() => _WorklogFormState();
}

class _WorklogFormState
    extends AddEditFormState<Worklog, TodayActivitiesProvider> {
  Worklog get item => _item;
  Worklog _item;

  _WorklogFormState() : super(LocaleKeys.label_worklogs);

  @override
  void setItem(Worklog itemToEdit) => _item = itemToEdit;

  @override
  Widget getHeader() => Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(_item.task.nomeCliente,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(_item.task.nomeTask.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(_item.task.nomeProgetto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white)),
                  ]),
            )
          ],
        ),
      );

  @override
  List<Widget> getFormElements() => [
        EasyTextField(
            key: ValueKey(_item.data ?? UniqueKey()),
            labelText: LocaleKeys.label_date,
            icon: EasyIcons.calendar,
            initialValue: _item.data?.formatDisplay(),
            onTap: () async {
              DateTime picked = await openDatePicker(item.data);
              if (picked != null) {
                setState(() {
                  item.data = picked;
                });
              }
            }),
        EasyTextField(
            key: ValueKey(_item.durata ?? UniqueKey()),
            labelText: LocaleKeys.label_time_spent,
            icon: EasyIcons.timer_off,
            initialValue: Duration(minutes: _item.durata ?? 0).formatDisplay(),
            onTap: () async {
              Duration picked = await _openDurationPicker(context);
              if (picked != null) {
                setState(() {
                  item.durata = picked.inMinutes;
                });
              }
            }),
        EasyTextField(
          labelText: LocaleKeys.label_description,
          icon: EasyIcons.description,
          initialValue: item.descrizione,
          maxLines: 3,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];

  Future<Duration> _openDurationPicker(BuildContext context) async {
    return showDurationDialog(
        context: context, initialValue: Duration(minutes: item.durata ?? 0));
  }

  @override
  void submitForm() async {
    final form = formKey.currentState;
    form.save();

    if (form.validate()) {
      FocusScope.of(context).unfocus();

      try {
        setState(() {
          loading = true;
        });

        // Add/edit the item
        final provider =
            Provider.of<TodayActivitiesProvider>(context, listen: false);
        final Task task = provider.getTask(item.task.id);
        final bool isNew = item.isNew;
        try {
          if (item.durata == 0) {
            // Delete worklog
            if (!isNew) await provider.deleteWorklog(task, item);
            onFormSubmitted(null, LocaleKeys.message_delete_generic);
          } else {
            // Add/edit worklog
            final result = await provider.addEditWorklog(task, item);
            onFormSubmitted(
                result,
                isNew
                    ? LocaleKeys.message_add_generic
                    : LocaleKeys.message_edit_generic);
          }
        } catch (e, s) {
          handleRestError(context, e, s);
        }
      } catch (e, s) {
        handleRestError(context, e, s);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
