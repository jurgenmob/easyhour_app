import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/company_action.dart';
import 'package:easyhour_app/providers/company_action_provider.dart';
import 'package:easyhour_app/widgets/app_bar.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CompanyActionsScreen extends StatefulWidget {
  @override
  createState() => _CompanyActionsScreenState();
}

class _CompanyActionsScreenState extends EasyListState<CompanyActionsScreen,
    CompanyAction, CompanyActionProvider> {
  _CompanyActionsScreenState() : super(refreshEnabled: false);

  @override
  Widget getItem(CompanyAction item) {
    return _CompanyActionButton(item);
  }
}

class _CompanyActionButton extends StatelessWidget {
  final CompanyAction item;

  const _CompanyActionButton(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ButtonTheme(
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 48),
          child: Row(
            children: [
              Icon(item.icon, color: Colors.white, size: 32),
              SizedBox(width: 16),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(item.text.plural(2).toUpperCase(),
                      style: Theme.of(context).textTheme.headline3),
                ),
              ),
            ],
          ),
          onPressed: () => EasyAppBar.pushNamed(context, item.route),
        ),
      ),
    );
  }
}
