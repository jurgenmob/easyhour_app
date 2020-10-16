import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/location.dart';
import 'package:easyhour_app/models/smart_working.dart';
import 'package:easyhour_app/providers/smart_working_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/button.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_select/smart_select.dart';

class SmartWorkingAddEditScreen extends BaseAddEditScreen<SmartWorking> {
  @override
  Widget getBody() => _SmartWorkingForm();
}

class _SmartWorkingForm extends StatefulWidget {
  @override
  createState() => _SmartWorkingFormState();
}

class _SmartWorkingFormState
    extends AddEditFormState<SmartWorking, SmartWorkingProvider> {
  SmartWorking get item => _item;
  SmartWorking _item;

  _SmartWorkingFormState() : super(LocaleKeys.label_smartworkings);

  @override
  void setItem(SmartWorking itemToEdit) {
    if (_item == null) _item = itemToEdit ?? SmartWorking();
  }

  @override
  List<Widget> getFormElements() => [
        _LocationSelectField(_item),
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
          initialValue: item.descrizione,
          maxLines: 3,
          isRequired: false,
          onSaved: (value) => _item.descrizione = value,
        ),
      ];
}

class _LocationSelectField extends StatefulWidget {
  final SmartWorking item;

  _LocationSelectField(this.item);

  @override
  _LocationSelectFieldState createState() => _LocationSelectFieldState();
}

class _LocationSelectFieldState extends State<_LocationSelectField> {
  bool _loading = false;
  List<S2Choice<Location>> _locations = [];

  @override
  void initState() {
    super.initState();

    _getLocations();
  }

  @override
  Widget build(BuildContext context) {
    // Autocomplete with first location if only one is found
    if (_locations?.length == 1) widget.item.location = _locations[0].value;

    final ThemeData theme = Theme.of(context);

    return _loading
        ? EasyLoader()
        : SmartSelect<Location>.single(
            title: LocaleKeys.label_locations.plural(1),
            placeholder: LocaleKeys.label_choose.tr(),
            value: widget.item.location,
            onChange: (state) =>
                setState(() => widget.item.location = state.value),
            choiceItems: _locations,
            choiceStyle: S2ChoiceStyle(
              titleStyle: theme.textTheme.button.copyWith(color: Colors.black),
              activeColor: theme.primaryColor,
            ),
            choiceEmptyBuilder: (context, value) => Center(
                  child: Text(LocaleKeys.message_no_locations.tr(),
                      style: theme.textTheme.bodyText1),
                ),
            modalFilter: true,
            modalFilterAuto: true,
            modalFilterHint: LocaleKeys.label_search.tr(),
            modalHeaderStyle: S2ModalHeaderStyle(
              iconTheme: theme.iconTheme,
              actionsIconTheme: theme.iconTheme,
            ),
            modalFooterBuilder: (context, state) {
              return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 7.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    child: EasyButton(
                      text: LocaleKeys.label_add.tr().toUpperCase(),
                      icon: Icons.add_location,
                      onPressed: () => _addLocation(state),
                    ),
                  ));
            },
            choiceConfig: S2ChoiceConfig(
              useDivider: true,
            ),
            tileBuilder: (context, state) {
              return EasyTextField(
                key: ValueKey(widget.item.location ?? UniqueKey()),
                labelText: LocaleKeys.label_locations.plural(1),
                icon: EasyIcons.location,
                initialValue: widget.item.location?.nome,
                onTap: state.showModal,
              );
            });
  }

  void _getLocations() async {
    try {
      setState(() => _loading = true);
      List<Location> locations = await EasyRest().getLocations();
      setState(() => _locations = S2Choice.listFrom<Location, dynamic>(
            source: locations,
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

  String _googleMapsApiKey;

  void _addLocation(S2State state) async {
    // Read maps key
    if (_googleMapsApiKey == null) {
      _googleMapsApiKey = await googleMapsApyKey;
    }

    // Show location picker
    LocationResult location = await showLocationPicker(
      context,
      _googleMapsApiKey,
      initialCenter: LatLng(44.488333, 11.260644),
      myLocationButtonEnabled: true,
      // countries: ['IT'],
      appBarColor: Colors.white,
      searchBarBoxDecoration: BoxDecoration(),
      hintText: LocaleKeys.label_search.tr(),
      language: Localizations.localeOf(context).languageCode,
      desiredAccuracy: LocationAccuracy.best,
    );
    if (location == null) return;

    String locationName = await showTextInputDialog(
      context,
      title: LocaleKeys.label_save_location_as.tr(),
      labelText: LocaleKeys.label_enter_location_name.tr(),
      okBtnText: LocaleKeys.label_save.tr(),
    );

    if (locationName?.isNotEmpty ?? false) {
      widget.item.location = Location(
        nome: locationName,
        lat: location.latLng.latitude,
        lnt: location.latLng.longitude,
      );

      // Add the new location
      _locations.add(S2Choice(
        value: widget.item.location,
        title: widget.item.location.nome,
        meta: widget.item.location,
        selected: true,
      ));
      setState(() {
        state.changes.commit(widget.item.location, selected: true);
      });

      state.closeModal(confirmed: true);
    }
  }
}
