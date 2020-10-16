import 'package:easyhour_app/providers/company_action_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';

class CompanyAction with BaseModel {
  final String text;
  final IconData icon;
  final String page;

  @override
  get id => text.hashCode;

  @override
  get listTitle => text;

  @override
  CompanyActionProvider provider(BuildContext context) =>
      context.read<CompanyActionProvider>();

  CompanyAction(
      {@required this.text, @required this.icon, @required this.page});
}
