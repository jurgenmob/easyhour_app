import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/activity.dart';
import 'package:easyhour_app/providers/activity_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class ActivityAddEditScreen extends BaseAddEditScreen<Activity> {
  @override
  Widget getBody() => _ActivityForm();
}

class _ActivityForm extends StatefulWidget {
  @override
  createState() => _ActivityFormState();
}

class _ActivityFormState extends AddEditFormState<Activity, ActivityProvider> {
  Activity get item => _item;
  Activity _item;

  @override
  void setItem(Activity itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Activity();
  }

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
            key: ValueKey(_item.oraInizio ?? UniqueKey()),
            labelText: LocaleKeys.label_time_start,
            icon: EasyIcons.timer_off,
            initialValue: _item.oraInizio?.asTimeOfDay()?.formatDisplay(),
            onTap: () async {
              TimeOfDay picked = await openTimePicker(
                  (item.oraInizio ?? "8:00")?.asTimeOfDay());
              if (picked != null) {
                setState(() {
                  item.oraInizio = picked.formatRest();
                });
              }
            }),
        EasyTextField(
            key: ValueKey(_item.oraFine ?? UniqueKey()),
            labelText: LocaleKeys.label_time_end,
            icon: EasyIcons.timer_off,
            initialValue: _item.oraFine?.asTimeOfDay()?.formatDisplay(),
            onTap: () async {
              TimeOfDay picked = await openTimePicker(
                  (item.oraFine ?? "18:00")?.asTimeOfDay());
              if (picked != null) {
                setState(() {
                  item.oraFine = picked.formatRest();
                });
              }
            }),
        EasyTextField(
          labelText: LocaleKeys.label_type,
          icon: EasyIcons.description,
          initialValue: item.tipologia,
          isRequired: false,
          onSaved: (value) => _item.tipologia = value,
        ),
        EasyTextField(
          labelText: LocaleKeys.label_description,
          icon: EasyIcons.description,
          initialValue: item.descrizione,
          maxLines: 3,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];
}
