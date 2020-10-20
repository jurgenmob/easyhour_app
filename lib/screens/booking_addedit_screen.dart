import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/booking.dart';
import 'package:easyhour_app/models/workplace.dart';
import 'package:easyhour_app/providers/booking_provider.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/add_edit_form.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

final _bookingFormKey = GlobalKey<_BookingFormState>();
final _workPlacesSelectKey = GlobalKey<_WorkPlaceSelectFieldState>();

class BookingAddEditScreen extends BaseAddEditScreen<Booking> {
  @override
  Widget getBody() => _BookingForm();
}

class _BookingForm extends StatefulWidget {
  _BookingForm() : super(key: _bookingFormKey);

  @override
  createState() => _BookingFormState();
}

class _BookingFormState extends AddEditFormState<Booking, BookingProvider> {
  Booking get item => _item;
  Booking _item;

  @override
  void setItem(Booking itemToEdit) {
    if (_item == null) _item = itemToEdit ?? Booking();
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
                _workPlacesSelectKey.currentState.refreshWorkPlaces();
              }
            }),
        _WorkPlaceSelectField(_item, editable: _item.dateRange != null),
      ];
}

class _WorkPlaceSelectField extends StatefulWidget {
  final Booking item;
  final bool editable;

  _WorkPlaceSelectField(this.item, {this.editable = true})
      : super(key: _workPlacesSelectKey);

  @override
  _WorkPlaceSelectFieldState createState() => _WorkPlaceSelectFieldState();
}

class _WorkPlaceSelectFieldState extends State<_WorkPlaceSelectField> {
  bool _loading = false;
  List<S2Choice<WorkPlace>> _workplaces = [];

  void refreshWorkPlaces() {
    setState(() => _workplaces = null);
  }

  @override
  Widget build(BuildContext context) {
    // Load available work places
    if (widget.item.dateRange != null && _workplaces == null) _getWorkplaces();

    // Autocomplete with first location if only one is found
    if (_workplaces?.length == 1) widget.item.postazione = _workplaces[0].value;

    return _loading
        ? EasyLoader()
        : SmartSelect<WorkPlace>.single(
            title: LocaleKeys.label_workplaces.plural(1),
            placeholder: LocaleKeys.label_choose.tr(),
            value: widget.item.postazione,
            onChange: (state) {
              setState(() => widget.item.postazione = state.value);
              _bookingFormKey.currentState.setState(() {});
            },
            choiceItems: _workplaces,
            choiceStyle: S2ChoiceStyle(
              titleStyle: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.black),
              activeColor: Theme.of(context).primaryColor,
            ),
            choiceEmptyBuilder: (context, value) => Center(
                  child: Text(LocaleKeys.message_no_workplaces.tr(),
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
                    key: ValueKey(widget.item.postazione ?? UniqueKey()),
                    labelText: LocaleKeys.label_workplaces.plural(1),
                    icon: EasyIcons.workplaces,
                    maxLines: 3,
                    initialValue: widget.item.formatDisplay(),
                    enabled: widget.editable,
                    onTap: widget.editable ? state.showModal : null),
              );
            });
  }

  void _getWorkplaces() async {
    try {
      setState(() => _loading = true);
      List<WorkPlace> workplaces =
          await EasyRest().getWorkPlaces(widget.item.dateRange);
      setState(() => _workplaces = S2Choice.listFrom<WorkPlace, dynamic>(
            source: workplaces,
            value: (index, item) => item,
            title: (index, item) => item.nome,
            group: (index, item) => item.ufficio.nome,
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
