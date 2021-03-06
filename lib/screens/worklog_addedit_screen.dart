import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/task.dart';
import 'package:easyhour_app/models/worklog.dart';
import 'package:easyhour_app/providers/task_provider.dart';
import 'package:easyhour_app/providers/today_activities_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/task_list_item.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

final _worklogFormKey = GlobalKey<_WorklogFormState>();

class WorklogAddEditScreen extends BaseAddEditScreen<WorkLog> {
  @override
  Widget getBody() => _WorklogForm();
}

class _WorklogForm extends StatefulWidget {
  _WorklogForm() : super(key: _worklogFormKey);

  @override
  createState() => _WorklogFormState();
}

class _WorklogFormState
    extends AddEditFormState<WorkLog, TodayActivitiesProvider> {
  WorkLog get item => _item;
  WorkLog _item;
  bool editableTask = true;
  TextEditingController _descrController = TextEditingController();
  List<Widget> _suggestedDescriptions;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_item.task != null) {
        // Load suggested descriptions for this task
        _loadSuggestedDescriptions();

        // Show hours picker at startup if modifying an existing worklog
        _openDurationPicker(context);
        editableTask = false;
      }
    });
  }

  @override
  void setItem(WorkLog itemToEdit) {
    _item = itemToEdit;
    _descrController.text = _item.descrizione;
  }

  void _loadSuggestedDescriptions() {
    if (mounted) {
      EasyRest().getSuggestedDescriptions(_item.task).then((value) => setState(
          () => _suggestedDescriptions = value
              .map((e) => SuggestedDescription(e, _descrController))
              .toList()));
    }
  }

  @override
  Widget getHeader() => _item.task != null
      ? Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TaskListItem(_item.task,
                    heroTag: "task-${_item.task.id}",
                    alignment: CrossAxisAlignment.center),
              )
            ],
          ),
        )
      : null;

  @override
  List<Widget> getFormElements() => [
        _TaskSelectField(_item, editable: editableTask),
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
            onTap: () => _openDurationPicker(context),
            validator: (value) {
              // Allow 0 hours only when editing, it's a shortcut for delete
              return (item.durata == null || item.durata == 0) && item.isNew
                  ? LocaleKeys.field_is_required.tr()
                  : null;
            }),
        EasyTextField(
          labelText: LocaleKeys.label_description,
          icon: EasyIcons.description,
          initialValue: item.descrizione,
          maxLines: 3,
          controller: _descrController,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
        if (_suggestedDescriptions != null) ..._suggestedDescriptions
      ];

  void _openDurationPicker(BuildContext context) async {
    Duration picked = await showDurationDialog(
        context: context, initialValue: Duration(minutes: item.durata ?? 0));
    if (picked != null) {
      setState(() {
        item.durata = picked.inMinutes;
      });
    }
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
        final provider = context.read<TaskProvider>();
        Task task = provider.getTask(item.task.id);
        if (task == null) {
          await provider.get(); // may have never been initialized
          task = provider.getTask(item.task.id);
        }
        final bool isNew = item.isNew;
        try {
          if (item.durata == 0) {
            // Delete worklog
            if (!isNew) {
              await provider.deleteWorklog(context, task, item);
            }
            onFormSubmitted(null, LocaleKeys.message_delete_generic);
          } else {
            // Add/edit worklog
            final WorkLog result =
                await provider.addEditWorklog(context, task, item);
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

class _TaskSelectField extends StatefulWidget {
  final WorkLog item;
  final bool editable;

  _TaskSelectField(this.item, {this.editable = true});

  @override
  _TaskSelectFieldState createState() => _TaskSelectFieldState();
}

class _TaskSelectFieldState extends State<_TaskSelectField> {
  bool _loading = false;
  List<S2Choice<Task>> _tasks = [];

  @override
  void initState() {
    super.initState();

    _getTasks();
  }

  @override
  Widget build(BuildContext context) {
    // Autocomplete with first location if only one is found
    if (_tasks?.length == 1) widget.item.task = _tasks[0].value;

    return _loading
        ? EasyLoader()
        : SmartSelect<Task>.single(
            title: LocaleKeys.label_task.tr(),
            placeholder: LocaleKeys.label_choose.tr(),
            value: widget.item.task,
            onChange: (state) {
              setState(() => widget.item.task = state.value);
              _worklogFormKey.currentState
                ..setState(() {})
                .._loadSuggestedDescriptions();
            },
            choiceItems: _tasks,
            choiceStyle: S2ChoiceStyle(
              titleStyle: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.black),
              activeColor: Theme.of(context).primaryColor,
            ),
            choiceEmptyBuilder: (context, value) => Center(
                  child: Text(LocaleKeys.message_no_clients.tr(),
                      style: Theme.of(context).textTheme.bodyText1),
                ),
            choiceGrouped: true,
            modalFilter: true,
            modalFilterAuto: true,
            modalFilterHint: LocaleKeys.label_search.tr(),
            choiceConfig: S2ChoiceConfig(
              useDivider: true,
            ),
            tileBuilder: (context, state) {
              return Opacity(
                opacity: widget.editable ? 1.0 : 0.5,
                child: EasyTextField(
                  key: ValueKey(widget.item.task ?? UniqueKey()),
                  labelText: LocaleKeys.label_task,
                  icon: EasyIcons.profile,
                  initialValue: widget.item.task?.nomeTask,
                  enabled: widget.editable,
                  onTap: widget.editable ? state.showModal : null,
                ),
              );
            });
  }

  void _getTasks() async {
    try {
      setState(() => _loading = true);
      List<Task> tasks = await EasyRest().getTasks();
      setState(() => _tasks = S2Choice.listFrom<Task, dynamic>(
            source: tasks,
            value: (index, item) => item,
            title: (index, item) => item.nomeTask,
            subtitle: (index, item) => item.nomeProgetto,
            group: (index, item) => item.nomeCliente,
            meta: (index, item) => item,
          ));
    } catch (e, s) {
      print(e);
      print(s);
    } finally {
      setState(() => _loading = false);
    }
  }
}

class SuggestedDescription extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  SuggestedDescription(this.text, this.controller);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText2),
      onPressed: () async {
        controller.text = text;
      },
    );
  }
}
