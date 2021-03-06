import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/sickness.dart';
import 'package:easyhour_app/providers/sickness_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SicknessAddEditScreen extends BaseAddEditScreen<Sickness> {
  @override
  Widget getBody() => _SicknessForm();
}

class _SicknessForm extends StatefulWidget {
  @override
  createState() => _SicknessFormState();
}

class _SicknessFormState extends AddEditFormState<Sickness, SicknessProvider> {
  Sickness get item => _item;
  Sickness _item;

  @override
  void setItem(Sickness itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Sickness();
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
          labelText: LocaleKeys.label_medical_certificate,
          icon: EasyIcons.description,
          initialValue: item.descrizione,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];
}
