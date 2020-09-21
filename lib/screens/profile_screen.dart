import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/data/rest_utils.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/button.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:easyhour_app/widgets/version_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/locale_keys.g.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
        child: Scaffold(
            body: FutureBuilder<UserInfo>(
      future: EasyRest().getUserInfo(),
      builder: (context, snapshot) =>
          snapshot?.connectionState == ConnectionState.done
              ? _ProfileScreen(snapshot.data)
              : EasyLoader(),
    )));
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProfileScreen extends StatelessWidget {
  final UserInfo user;

  _ProfileScreen(this.user);

  @override
  Widget build(BuildContext context) {
    final flatButtonStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(color: Theme.of(context).primaryColor);

    return Stack(
      children: [
        Container(
            transform: Matrix4.translationValues(0.0, -60.0, 0.0),
            child: Image.asset('images/profile_bg.jpg')),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(children: [
            Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 4, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ]),
                child: Image.asset('images/logo.png')),
            Text("${user.userDTO.firstName} ${user.userDTO.lastName}",
                style: Theme.of(context).textTheme.headline1),
            SizedBox(height: 8),
            Text(user.userDTO.email,
                style: Theme.of(context).textTheme.bodyText1),
            Spacer(flex: 1),
            FlatButton(
              child:
                  Text(LocaleKeys.label_my_places.tr(), style: flatButtonStyle),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            FlatButton(
              child: Text(LocaleKeys.label_help_videos.tr(),
                  style: flatButtonStyle),
              onPressed: () => launch(helpVideosUrl),
            ),
            FlatButton(
              child: Text(LocaleKeys.label_reset_password.tr(),
                  style: flatButtonStyle),
              onPressed: () => launch(resetPasswordUrl),
            ),
            Spacer(flex: 3),
            EasyButton(
              text: LocaleKeys.label_logout.tr().toUpperCase(),
              icon: EasyIcons.logout,
              onPressed: () {
                EasyRest().doLogout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', ModalRoute.withName('/'));
              },
            ),
            SizedBox(height: 8),
            FlatButton(
              child: Text(LocaleKeys.label_privacy_policy.tr(),
                  style: flatButtonStyle),
              onPressed: () => launch(privacyUrl),
            ),
            SizedBox(height: 8),
            VersionText(),
          ]),
        )
      ],
    );
  }
}
