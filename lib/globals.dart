import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/user_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

// Roles constants
const String roleReporter = "ROLE_REPORTER";
const String roleAdmin = "ROLE_ADMIN";

// Profile links
const helpVideosUrl =
    'https://www.youtube.com/channel/UCXoLKcYQOyRKmgOziIpm9CQ';
const resetPasswordUrl = '$baseUrl/webapp/#/auth/reset';
const privacyUrl = '$baseUrl/informativa-privacy';

/// Minute interval for worklogs
const worklogMinuteInterval = 5;

/// Validates an email address.
bool validateEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

/// Validates an integer number.
bool validateInt(String text) => RegExp(r"^[0-9]+$").hasMatch(text);

/// Access to shared preferences
SharedPreferences prefs;

/// User and company info and config
UserInfo userInfo;

extension IntUtils on num {
  String padLeft(int width, [String padding = '0']) =>
      this.toString().padLeft(width, padding);
}

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
  String formatDisplay() => "$hour:" + minute.padLeft(2);

  String formatRest() => "$hour:" + minute.padLeft(2);
}

extension ParseTimeUtils on String {
  TimeOfDay asTimeOfDay() {
    final List<String> tokens = split(":");
    return TimeOfDay(hour: int.parse(tokens[0]), minute: int.parse(tokens[1]));
  }
}

extension DurationUtils on Duration {
  String formatDisplay({bool showSeconds = false, bool showZero = true}) =>
      (inMilliseconds > 0 || (showZero && inMilliseconds >= 0))
          ? inHours.padLeft(2) +
              ":" +
              inMinutes.remainder(60).padLeft(2) +
              (showSeconds ? ":" + inSeconds.remainder(60).padLeft(2) : "")
          : null;

  int formatRest() => inMinutes;
}

Future<String> get googleMapsApyKey async {
  final keyName =
      "GOOGLE_MAPS_API_KEY_${Platform.operatingSystem.toUpperCase()}";
  String content = await rootBundle.loadString('secure.properties');
  List<String> prop = content
      .split("\n")
      .firstWhere((e) => e.trim().startsWith("$keyName="), orElse: () => null)
      ?.split("=");
  return prop?.length == 2 ? prop[1] : null;
}
