import 'package:easyhour_app/providers/company_action_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';

class CompanyAction with BaseModel {
  final String text;
  final IconData icon;
  final String page;

  int get id => text.hashCode;

  @override
  String get listTitle => text;

  @override
  DateTimeRange get dateRange => null;

  @override
  CompanyActionProvider provider(BuildContext context) =>
      Provider.of<CompanyActionProvider>(context, listen: false);

  CompanyAction(
      {@required this.text, @required this.icon, @required this.page});
}
