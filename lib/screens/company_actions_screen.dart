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
  MaterialColor _colors;

  Color _getColor(int index) {
    switch (index % 10) {
      case 0:
        return _colors.shade50;
      case 1:
        return _colors.shade100;
      case 2:
        return _colors.shade200;
      case 3:
        return _colors.shade300;
      case 4:
        return _colors.shade400;
      case 5:
        return _colors.shade500;
      case 6:
        return _colors.shade600;
      case 7:
        return _colors.shade700;
      case 8:
        return _colors.shade800;
      case 9:
      default:
        return _colors.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    _colors = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: super.build(context),
    );
  }

  @override
  Widget getItem(int index, CompanyAction item) {
    return _CompanyActionButton(item, color: _getColor(index));
  }
}

class _CompanyActionButton extends StatelessWidget {
  final CompanyAction item;
  final Color color;

  const _CompanyActionButton(this.item, {Key key, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: RaisedButton(
        color: color ?? Theme.of(context).primaryColor,
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
    );
  }
}
