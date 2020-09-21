import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../generated/locale_keys.g.dart';

class VersionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) => Text(
          snapshot.connectionState == ConnectionState.done
              ? LocaleKeys.app_version.tr(args: [
                  "${snapshot.data.version}-${snapshot.data.buildNumber}"
                ])
              : "",
          style: Theme.of(context).textTheme.caption),
    );
  }
}
