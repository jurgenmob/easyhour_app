import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/client.dart';
import 'package:easyhour_app/models/trip.dart';
import 'package:easyhour_app/providers/trip_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class TripAddEditScreen extends BaseAddEditScreen<Trip> {
  @override
  Widget getBody() => _TripForm();
}

class _TripForm extends StatefulWidget {
  @override
  createState() => _TripFormState();
}

class _TripFormState extends AddEditFormState<Trip, TripProvider> {
  Trip get item => _item;
  Trip _item;

  String _attachmentsNames;
  List<PlatformFile> _attachments;

  @override
  void setItem(Trip itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Trip();
  }

  @override
  List<Widget> getFormElements() => [
        _ClientSelectField(_item),
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
            key: ValueKey(_attachmentsNames ?? UniqueKey()),
            labelText: LocaleKeys.label_attachments,
            icon: EasyIcons.attachment,
            initialValue: _attachmentsNames,
            isRequired: false,
            onTap: _openFileExplorer),
        EasyTextField(
          labelText: LocaleKeys.label_description,
          icon: EasyIcons.description,
          initialValue: item.descrizione,
          maxLines: 3,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];

  @override
  void onFormSubmitted(Trip newItem, String confirmMsg) async {
    // Send attachments if needed
    if (_attachments?.isNotEmpty ?? false) {
      setState(() {
        loading = true;
      });

      _attachments.forEach((file) async {
        await EasyRest().uploadTripAttachment(newItem, file);
      });

      setState(() {
        loading = false;
      });
    }

    super.onFormSubmitted(newItem, confirmMsg);
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
        // allowedExtensions: ['.pdf', '.jpg'],
      );

      // Set attachments and display name
      _attachments = result?.files;
      _attachmentsNames = LocaleKeys.label_attachments_selected
          .plural(_attachments?.length ?? 0);
    } catch (e, s) {
      print(e);
      print(s);

      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }
}

class _ClientSelectField extends StatefulWidget {
  final Trip item;

  _ClientSelectField(this.item);

  @override
  _ClientSelectFieldState createState() => _ClientSelectFieldState();
}

class _ClientSelectFieldState extends State<_ClientSelectField> {
  bool _loading = false;
  List<S2Choice<Client>> _clients = [];

  @override
  void initState() {
    super.initState();

    _getClients();
  }

  @override
  Widget build(BuildContext context) {
    // Autocomplete with first location if only one is found
    if (_clients?.length == 1) widget.item.cliente = _clients[0].value;

    return _loading
        ? EasyLoader()
        : SmartSelect<Client>.single(
            title: LocaleKeys.label_client.tr(),
            placeholder: LocaleKeys.label_choose.tr(),
            value: widget.item.cliente,
            onChange: (state) =>
                setState(() => widget.item.cliente = state.value),
            choiceItems: _clients,
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
            modalFilter: true,
            modalFilterAuto: true,
            modalFilterHint: LocaleKeys.label_search.tr(),
            choiceConfig: S2ChoiceConfig(
              useDivider: true,
            ),
            tileBuilder: (context, state) {
              return EasyTextField(
                key: ValueKey(widget.item.cliente ?? UniqueKey()),
                labelText: LocaleKeys.label_client,
                icon: EasyIcons.profile,
                initialValue: widget.item.cliente?.nome,
                onTap: state.showModal,
              );
            });
  }

  void _getClients() async {
    try {
      setState(() => _loading = true);
      List<Client> clients = await EasyRest().getClients();
      setState(() => _clients = S2Choice.listFrom<Client, dynamic>(
            source: clients,
            value: (index, item) => item,
            title: (index, item) => item.nome,
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
