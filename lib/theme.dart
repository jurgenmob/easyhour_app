import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final appTheme = ThemeData(
    primaryColor: const Color(0xFF00ADE6),
    primarySwatch: MaterialColor(
      0xFF0683F4,
      <int, Color>{
        50: const Color(0xFF1CD9FE),
        100: const Color(0xFF38C0FE),
        200: const Color(0xFF5AB1F2),
        300: const Color(0xFF4FACFE),
        400: const Color(0xFF4286F4),
        500: const Color(0xFF0683F4),
        600: const Color(0xFF254EB7),
        700: const Color(0xFF0A33E9),
        800: const Color(0xFF2479B9),
        900: const Color(0xFF004A9F),
      },
    ),
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      // Es. nome nel profilo (3.6rem)
      headline1: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: const Color(0xFF666666),
      ),
      // Icone bottom bar (3rem)
      headline2: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 42,
        color: Colors.white,
      ),
      // Es. i pulsanti "Ferie", "Malattia", etc. (2.5rem)
      headline3: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 26,
        color: Colors.white,
      ),
      // Nomi dei task e pulsanti (2rem)
      subtitle1: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 22,
        color: Colors.black,
      ),
      // Pulsanti (2rem)
      button: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 22,
        color: Colors.white,
      ),
      // Scritte tipo la data (1.4rem)
      bodyText1: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: const Color(0xFF888888),
      ),
      // Scritte in piccolo nelle liste
      bodyText2: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        fontSize: 16,
        color: const Color(0xFF888888),
      ),
    ),
    iconTheme: new IconThemeData(
      color: const Color(0xFF00ADE6),
    ));

const snackBarStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  fontSize: 16,
  color: const Color(0xFFFFFFFF),
);

// Calendar colors
class EasyColors {
  static const calOk = Colors.greenAccent;
  static const calMissing = Colors.red;
  static const calTooMuch = Colors.yellow;
  static const approve = Colors.green;
  static const refuse = Colors.red;
}

class EasyIcons {
  EasyIcons._();

  // Tabs
  static const IconData home = _EasyIconsData(0xe976);
  static const IconData home_filled = _EasyIconsData(0xe975);
  static const IconData company = _EasyIconsData(0xe9f5);
  static const IconData company_filled = _EasyIconsData(0xe91b);
  static const IconData profile = _EasyIconsData(0xe9b7);
  static const IconData profile_filled = _EasyIconsData(0xe9b5);
  static const IconData chart = _EasyIconsData(0xe9f7);
  static const IconData chart_filled = _EasyIconsData(0xe9bf);

  // Company actions
  static const IconData vacations = _EasyIconsData(0xe95e);
  static const IconData permits = _EasyIconsData(0xe9b3);
  static const IconData sickness = _EasyIconsData(0xe995);
  static const IconData trips = _EasyIconsData(0xe9e8);
  static const IconData activities = _EasyIconsData(0xe911);
  static const IconData smartworkings = _EasyIconsData(0xe9d5);
  static const IconData workplaces = _EasyIconsData(0xe922);
  static const IconData requests = _EasyIconsData(0xe92e);

  // Misc
  static const IconData login = _EasyIconsData(0xe98d);
  static const IconData logout = _EasyIconsData(0xe992);
  static const IconData delete = Icons.delete;
  static const IconData search = _EasyIconsData(0xe9f4);
  static const IconData timer_on = _EasyIconsData(0xe942);
  static const IconData timer_off = _EasyIconsData(0xe943);
  static const IconData timer_filled = _EasyIconsData(0xe941);
  static const IconData calendar = _EasyIconsData(0xe920);
  static const IconData calendar_today = _EasyIconsData(0xe973);
  static const IconData arrow_left = _EasyIconsData(0xe981);
  static const IconData arrow_right = _EasyIconsData(0xe9cd);
  static const IconData description = _EasyIconsData(0xe948);
  static const IconData lock = _EasyIconsData(0xe9B0);
  static const IconData save = _EasyIconsData(0xe9cf);
  static const IconData save_filled = _EasyIconsData(0xe9ce);
  static const IconData location = _EasyIconsData(0xe997);
  static const IconData position = _EasyIconsData(0xea12);
  static const IconData add = _EasyIconsData(0xe901);
  static const IconData attachment = _EasyIconsData(0xe902);
  static const IconData workman = _EasyIconsData(0xe94e);
  static const IconData workman_filled = _EasyIconsData(0xe949);
  static const IconData settings = _EasyIconsData(0xe977);
  static const IconData approve_ok = Icons.thumb_up;
  static const IconData approve_ko = Icons.thumb_down;
  static const IconData approve_pending = Icons.hourglass_full;
}

class _EasyIconsData extends IconData {
  const _EasyIconsData(int codePoint)
      : super(codePoint, fontFamily: 'EasyIcons');
}
