import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class EasyDialog {
  static Future<bool> confirmDeleteDialog(
          BuildContext context, String message) =>
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

  static Future<String> textInputDialog(BuildContext context,
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
}
