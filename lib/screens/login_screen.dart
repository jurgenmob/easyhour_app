import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/button.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/text_field.dart';
import 'package:easyhour_app/widgets/version_info.dart';
import 'package:flutter/material.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: _LoginForm())));
  }
}

class _LoginForm extends StatefulWidget {
  @override
  createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String _domain;
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/logo_or.png',
            fit: BoxFit.fitWidth,
          ),
          Spacer(flex: 1),
          EasyTextField(
            labelText: LocaleKeys.label_domain,
            helperText: LocaleKeys.help_domain,
            icon: EasyIcons.company,
            initialValue: EasyRest().domain,
            onSaved: (value) => _domain = value,
          ),
          EasyTextField(
            labelText: LocaleKeys.label_username,
            keyboardType: TextInputType.emailAddress,
            icon: EasyIcons.profile,
            initialValue: EasyRest().username,
            validator: (value) => validateEmail(value)
                ? null
                : LocaleKeys.field_email_invalid.tr(),
            onSaved: (value) => _username = value,
          ),
          EasyTextField(
            labelText: LocaleKeys.label_password,
            icon: EasyIcons.lock,
            obscureText: true,
            isLast: true,
            onSaved: (value) => _password = value,
          ),
          Spacer(flex: 2),
          loading
              ? EasyLoader()
              : EasyButton(
                  text: LocaleKeys.label_login.tr().toUpperCase(),
                  icon: EasyIcons.login,
                  onPressed: onPressed,
                ),
          SizedBox(height: 8),
          VersionText(),
        ],
      ),
    );
  }

  void onPressed() {
    final form = _formKey.currentState;
    form.save();

    if (form.validate()) {
      setState(() {
        loading = true;
      });

      FocusScope.of(context).unfocus();

      EasyRest().doLogin(_domain, _username, _password).then((resultOk) {
        if (resultOk) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showMessage(
              _scaffoldKey.currentState, LocaleKeys.message_login_failed.tr());
        }

        setState(() {
          loading = false;
        });
      });
    }
  }
}
