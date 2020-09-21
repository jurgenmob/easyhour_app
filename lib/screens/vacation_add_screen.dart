import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/vacation.dart';
import 'package:easyhour_app/providers/app_bar_provider.dart';
import 'package:easyhour_app/providers/vacation_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class VacationAddScreen extends BaseScreen {
  @override
  Widget getBody() => _VacationForm();

  @override
  EasyAppBarAction getEasyAppBarAction() => null;
}

class _VacationForm extends StatefulWidget {
  @override
  createState() => _VacationFormState();
}

class _VacationFormState extends AddEditFormState<Vacation, VacationProvider> {
  Vacation _item;

  Vacation get item => _item;

  _VacationFormState() : super(LocaleKeys.label_vacations);

  @override
  void setItem(Vacation itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Vacation();
  }

  @override
  List<Widget> getFormElements() => [
        EasyTextField(
            key: ValueKey(_item.dateRange ?? UniqueKey()),
            labelText: LocaleKeys.label_date_range,
            icon: EasyIcons.calendar,
            initialValue: _item.dateRange?.formatDisplay(),
            onTap: () async {
              DateTimeRange picked = await openDateRangePicker(item.dateRange);
              if (picked != null) {
                setState(() {
                  item.dataInizio = picked.start;
                  item.dataFine = picked.end;
                });
              }
            }),
        EasyTextField(
          labelText: LocaleKeys.label_description,
          icon: EasyIcons.description,
          maxLines: 3,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];
}
