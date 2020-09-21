import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class EasyDialog {
  static Future<bool> confirmDeleteDialog(
      BuildContext context, String message) {
    Widget cancelButton = FlatButton(
      child: Text(LocaleKeys.label_cancel.tr()),
      onPressed: () => Navigator.of(context).pop(false),
    );
    Widget continueButton = FlatButton(
      child: Text(LocaleKeys.label_ok.tr()),
      onPressed: () => Navigator.of(context).pop(true),
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }
}
