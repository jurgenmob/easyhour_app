import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final appTheme = ThemeData(
    primaryColor: Color(0xFF00ADE6),
//  primarySwatch: Colors.blue,
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

class EasyIcons {
  EasyIcons._();

  // Tabs
  static const IconData home = _EasyIconsData(0xe976);
  static const IconData company = _EasyIconsData(0xe9f5);
  static const IconData profile = _EasyIconsData(0xe9b7);

  // Company actions
  static const IconData vacations = _EasyIconsData(0xe95e);
  static const IconData permits = _EasyIconsData(0xe9b3);
  static const IconData sickness = _EasyIconsData(0xe995);
  static const IconData trips = _EasyIconsData(0xe9e8);
  static const IconData activities = _EasyIconsData(0xe911);
  static const IconData smartworkings = _EasyIconsData(0xe9d5);
  static const IconData workplaces = _EasyIconsData(0xe94e);

  // Misc
  static const IconData login = _EasyIconsData(0xe98d);
  static const IconData logout = _EasyIconsData(0xe992);
  static const IconData delete = _EasyIconsData(0xe92d);
  static const IconData search = _EasyIconsData(0xe9f4);
  static const IconData timer_on = _EasyIconsData(0xe942);
  static const IconData timer_off = _EasyIconsData(0xe943);
  static const IconData timer_filled = _EasyIconsData(0xe941);
  static const IconData calendar = _EasyIconsData(0xe920);
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
  static const IconData workplaces_filled = _EasyIconsData(0xe949);
  static const IconData settings = _EasyIconsData(0xe977);
}

class _EasyIconsData extends IconData {
  const _EasyIconsData(int codePoint)
      : super(codePoint, fontFamily: 'EasyIcons');
}
