import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

Future<bool> showConfirmDialog(BuildContext context, String message) =>
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            FlatButton(
              child: Text(LocaleKeys.label_cancel.tr()),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(LocaleKeys.label_ok.tr()),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

Future<String> showTextInputDialog(BuildContext context,
    {String title,
    String initialText,
    String labelText,
    String hintText,
    String okBtnText}) {
  final _formKey = GlobalKey<FormState>();
  String text = initialText;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: new TextFormField(
            autofocus: true,
            initialValue: initialText,
            decoration:
                new InputDecoration(labelText: labelText, hintText: hintText),
            onChanged: (value) {
              text = value;
            },
            validator: (value) {
              return value.isEmpty ? LocaleKeys.field_is_required.tr() : null;
            },
          ),
        ),
        actions: [
          FlatButton(
            child: Text(LocaleKeys.label_cancel.tr()),
            onPressed: () => Navigator.of(context).pop(""),
          ),
          FlatButton(
            child: Text(okBtnText ?? LocaleKeys.label_ok.tr()),
            onPressed: () {
              final form = _formKey.currentState;
              form.save();
              if (form.validate()) {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(text);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<Duration> showDurationDialog(
    {@required BuildContext context, Duration initialValue}) {
  Duration result;

  final TextStyle buttonStyle = Theme.of(context)
      .textTheme
      .button
      .copyWith(color: Theme.of(context).primaryColor);
  Widget cancelButton = FlatButton(
    child: Text(LocaleKeys.label_cancel.tr(), style: buttonStyle),
    onPressed: () => Navigator.of(context).pop(null),
  );
  Widget okButton = FlatButton(
    child: Text(LocaleKeys.label_ok.tr(), style: buttonStyle),
    onPressed: () => Navigator.of(context).pop(result),
  );

  return showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    minuteInterval: worklogMinuteInterval,
                    initialTimerDuration: initialValue,
                    onTimerDurationChanged: (Duration value) {
                      result = value;
                    },
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [cancelButton, okButton])
              ],
            ));
      });
}

Future showCustomDialog(BuildContext context,
    {String title, @required Widget content}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? ""),
        content: content,
        actions: [
          FlatButton(
            child: Text(LocaleKeys.label_cancel.tr()),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
