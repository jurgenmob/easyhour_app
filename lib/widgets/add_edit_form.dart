import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/base_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/button.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: refactor as Widget instead of state
abstract class AddEditFormState<T extends BaseModel, P extends BaseProvider>
    extends State {
  @protected
  final formKey = GlobalKey<FormState>();

  T get item;

  final String itemName;

  void setItem(T itemToEdit);

  @protected
  Widget getHeader() => null;

  @protected
  List<Widget> getFormElements();

  @protected
  bool loading = false;

  AddEditFormState(this.itemName);

  @override
  Widget build(BuildContext context) {
    // Get the item to edit, or generate a new item
    setItem(ModalRoute.of(context).settings.arguments);

    return Column(children: [
      getHeader() ?? _AddEditFormHeader(itemName),
      Spacer(flex: 1),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getFormElements(),
            ),
          )),
      Spacer(flex: 2),
      Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: loading
              ? EasyLoader()
              : EasyButton(
                  text: LocaleKeys.label_save.tr().toUpperCase(),
                  icon: EasyIcons.save_filled,
                  onPressed: submitForm,
                )),
    ]);
  }

  @protected
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
        final bool isNew = item.isNew;
        final provider = Provider.of<P>(context, listen: false);
        final result =
            await ((isNew) ? provider.add(item) : provider.edit(item));

        onFormSubmitted(
            result,
            isNew
                ? LocaleKeys.message_add_generic
                : LocaleKeys.message_edit_generic);
      } catch (e, s) {
        handleRestError(context, e, s);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @protected
  void onFormSubmitted(T newItem, String confirmMsg) {
    // Go back with confirmation message
    Navigator.pop(context, confirmMsg.tr());
  }

  @protected
  Future<DateTimeRange> openDateRangePicker(DateTimeRange initialDateRange) {
    final now = DateTime.now();
    return showDateRangePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        },
        firstDate: DateTime(now.year),
        lastDate: DateTime(now.year + 2),
        initialDateRange: initialDateRange ??
            DateTimeRange(
                start: now.add(Duration(days: 1)),
                end: now.add(Duration(days: 7))));
  }

  @protected
  Future<DateTime> openDatePicker(DateTime initialDate) {
    final now = DateTime.now();
    return showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        },
        firstDate: DateTime(now.year),
        lastDate: DateTime(now.year + 2),
        initialDate: initialDate ?? now.add(Duration(days: 1)));
  }

  @protected
  Future<TimeOfDay> openTimePicker(TimeOfDay initialTime) {
    return showTimePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        },
        initialTime: initialTime ?? TimeOfDay.fromDateTime(DateTime.now()));
  }
}

class _AddEditFormHeader extends StatelessWidget {
  final String itemName;

  _AddEditFormHeader(this.itemName);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
            padding: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Text(itemName.plural(1).toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3)),
      ),
    ]);
  }
}
