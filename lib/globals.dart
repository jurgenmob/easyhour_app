import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Swtich between DEV and PROD environments
const String baseUrl =
    kReleaseMode ? 'https://easyhour.app' : 'https://easyhour.mobidev.it';

const String restDateFormat = "yyyy-MM-dd";
const String displayDateFormat = "dd/MM/yyyy";

// Modules constants
const int timerModuleId = 1;
const int smartWorkingModuleId = 2;
const int activitiesModuleId = 3;
const int phasesModuleId = 7;
const String approvedValue = "APPROVATO";

// Profile links
const helpVideosUrl =
    'https://www.youtube.com/channel/UCXoLKcYQOyRKmgOziIpm9CQ';
const resetPasswordUrl = '$baseUrl/webapp/#/auth/login';
const privacyUrl = '$baseUrl/informativa-privacy';

/// Minute interval for worklogs
const worklogMinuteInterval = 5;

/// Validates an email address.
bool validateEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

/// Access to shared preferences
SharedPreferences prefs;

/// User and company info and config
UserInfo userInfo;

extension DateTimeUtils on DateTime {
  String formatDisplay() => DateFormat(displayDateFormat).format(this);

  String formatRest() => DateFormat(restDateFormat).format(this);
}

extension DateRangeTimeUtils on DateTimeRange {
  String formatDisplay() =>
      DateFormat(displayDateFormat).format(start) +
      " - " +
      DateFormat(displayDateFormat).format(end);
}

extension TimeOfDayUtils on TimeOfDay {
  String formatDisplay() => "$hour:" + minute.toString().padLeft(2, '0');

  String formatRest() => "$hour:" + minute.toString().padLeft(2, '0');
}

extension ParseTimeUtils on String {
  TimeOfDay asTimeOfDay() {
    final List<String> tokens = split(":");
    return TimeOfDay(hour: int.parse(tokens[0]), minute: int.parse(tokens[1]));
  }
}

extension DurationUtils on Duration {
  String twoDigits(int n) => (n >= 10) ? "$n" : "0$n";

  String formatDisplay({bool showSeconds = false, bool showZero = true}) =>
      (inMilliseconds > 0 || (showZero && inMilliseconds >= 0))
          ? twoDigits(inHours) +
              ":" +
              twoDigits(inMinutes.remainder(60)) +
              (showSeconds ? ":" + twoDigits(inSeconds.remainder(60)) : "")
          : null;

  int formatRest() => inMinutes;
}
