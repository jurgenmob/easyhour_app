import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/globals.dart';
import 'package:flutter/material.dart';

import 'package:easyhour_app/generated/locale_keys.g.dart';

class EasyTextField extends StatelessWidget {
  final Key key;
  final String labelText;
  final String helperText;
  final IconData icon;
  final dynamic initialValue;
  final bool enabled;
  final bool isLast;
  final bool isRequired;
  final bool obscureText;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final GestureTapCallback onTap;

  EasyTextField({
    this.key,
    @required this.labelText,
    this.helperText,
    this.icon,
    this.initialValue,
    this.enabled = true,
    this.isLast = false,
    this.isRequired = true,
    this.obscureText = false,
    this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSaved,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      key: key,
      decoration: InputDecoration(
        // FIXME: when using plural() string is already translated
        labelText: labelText.tr(),
        helperText: helperText?.tr(),
        suffixIcon: Icon(icon),
        // contentPadding: EdgeInsets.symmetric(vertical: 25),
        labelStyle: theme.textTheme.bodyText1.copyWith(color: Colors.black),
        enabled: enabled,
      ),
      style: theme.textTheme.bodyText1.copyWith(color: theme.primaryColor),
      initialValue: controller == null ? formatValue(initialValue) : null,
      obscureText: obscureText,
      controller: controller,
      maxLines: maxLines,
      keyboardType: maxLines == 1 ? keyboardType : TextInputType.multiline,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : (isLast ? TextInputAction.done : TextInputAction.next),
      onSaved: onSaved,
      onTap: onTap ?? () {},
      readOnly: onTap != null,
      showCursor: onTap == null,
      enabled: enabled,
      enableInteractiveSelection: onTap == null,
      validator: (value) {
        if (validator != null) {
          return validator.call(value);
        } else if (isRequired && value.isEmpty) {
          return LocaleKeys.field_is_required.tr();
        }
        return null;
      },
    );
  }

  String formatValue(v) => v?.runtimeType == DateTimeRange
      ? (v as DateTimeRange).formatDisplay()
      : v?.toString() ?? null;
}
