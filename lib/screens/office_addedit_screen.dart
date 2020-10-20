import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/office.dart';
import 'package:easyhour_app/providers/office_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class OfficeAddEditScreen extends BaseAddEditScreen<Office> {
  @override
  Widget getBody() => _OfficeForm();
}

class _OfficeForm extends StatefulWidget {
  @override
  createState() => _OfficeFormState();
}

class _OfficeFormState extends AddEditFormState<Office, OfficeProvider> {
  Office get item => _item;
  Office _item;

  @override
  void setItem(Office itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Office();
  }

  @override
  List<Widget> getFormElements() => [
        EasyTextField(
          labelText: LocaleKeys.label_office_name,
          icon: EasyIcons.description,
          initialValue: item.nome,
          onSaved: (value) => _item.nome = value,
        ),
        EasyTextField(
          labelText: LocaleKeys.label_workplaces_number,
          icon: EasyIcons.description,
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
          initialValue: item.quantita,
          onSaved: (value) => _item.quantita = int.parse(value),
          validator: (value) => validateInt(value) && int.parse(value) > 0
              ? null
              : LocaleKeys.field_int_number_invalid.tr(),
        ),
        EasyTextField(
          labelText: LocaleKeys.label_workplaces_prefix,
          icon: EasyIcons.description,
          initialValue: item.prefisso,
          isRequired: false,
          onSaved: (value) => _item.prefisso = value,
        ),
      ];
}
