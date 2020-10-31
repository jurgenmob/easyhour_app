import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EasyListItem<T extends BaseModel> extends StatelessWidget {
  final BaseModel item;

  final ConfirmDismissCallback confirmDismiss;
  final DismissDirectionCallback onDismissed;
  final IconData startIcon;
  final String startText;
  final IconData endIcon;
  final String endText;

  final Function(T) onEdit;
  final Function(T) onDelete;

  EasyListItem(this.item,
      {this.onEdit,
      this.onDelete,
      this.startIcon,
      this.startText,
      this.endIcon,
      this.endText,
      this.confirmDismiss,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    if (item.dismissible && item.editable) {
      return _dismissibleItem(context,
          child: _editableItem(context,
              child:
                  _EasyListItem(item, startIcon: startIcon, endIcon: endIcon)),
          bothDirections: startIcon != null);
    } else if (item.dismissible) {
      return _dismissibleItem(context,
          child: _readonlyItem(context,
              child:
                  _EasyListItem(item, startIcon: startIcon, endIcon: endIcon)),
          bothDirections: startIcon != null);
    } else if (item.editable) {
      return _editableItem(context, child: _EasyListItem(item));
    } else {
      return _readonlyItem(context, child: _EasyListItem(item));
    }
  }

  Widget _dismissibleItem(BuildContext context,
      {@required Widget child, bool bothDirections}) {
    return Dismissible(
        key: ValueKey(item.id),
        direction: item.dismissible != null
            ? bothDirections == true
                ? DismissDirection.horizontal
                : DismissDirection.endToStart
            : null,
        background: Container(
            color: EasyColors.approve,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(startIcon, color: Colors.white),
                if (startText != null) SizedBox(height: 4),
                if (startText != null) Text(startText, style: snackBarStyle)
              ],
            )),
        secondaryBackground: Container(
            color: EasyColors.refuse,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(endIcon, color: Colors.white),
                if (endText != null) SizedBox(height: 4),
                if (endText != null) Text(endText, style: snackBarStyle)
              ],
            )),
        confirmDismiss: (DismissDirection direction) async =>
            confirmDismiss != null
                ? confirmDismiss(direction)
                : await showConfirmDialog(
                    context,
                    LocaleKeys.message_delete_confirm
                        .tr(args: [item.listTitle.toLowerCase()])),
        onDismissed: (direction) =>
            onDismissed != null ? onDismissed(direction) : onDelete(item),
        child: child);
  }

  Widget _editableItem(BuildContext context, {@required Widget child}) {
    return Card(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: InkWell(onTap: () => onEdit(item), child: child));
  }

  Widget _readonlyItem(BuildContext context, {@required Widget child}) {
    return Card(margin: EdgeInsets.fromLTRB(4, 0, 4, 0), child: child);
  }
}

class _EasyListItem extends StatelessWidget {
  final BaseModel item;
  final IconData endIcon;
  final IconData startIcon;

  _EasyListItem(this.item, {this.endIcon, this.startIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          child: item.dismissible && startIcon != null
              ? _DismissIndicator(icon: startIcon, directionStart: true)
              : null,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (item.listSuptitle?.isNotEmpty ?? false)
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(item.listSuptitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                Text(
                    (item.listTitle ?? item.runtimeType.toString())
                        .toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                if (item.listSubtitle?.isNotEmpty ?? false)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(item.listSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.listDetailsTop != null)
                Text(item.listDetailsTop,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: item.highlightDetailsTop
                            ? FontWeight.bold
                            : FontWeight.normal)),
              if (item.listDetailsTop != null && item.listDetailsBtm != null)
                SizedBox(height: 8),
              if (item.listDetailsBtm != null)
                Text(item.listDetailsBtm,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: item.highlightDetailsBtm
                            ? FontWeight.bold
                            : FontWeight.normal))
            ]),
        SizedBox(width: 4),
        if (item.approvedIcon != null)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child:
                Icon(item.approvedIcon, color: Theme.of(context).primaryColor),
          ),
        Container(
          height: 100,
          child: item.dismissible ? _DismissIndicator(icon: endIcon) : null,
        ),
      ],
    );
  }
}

class _DismissIndicator extends StatelessWidget {
  final IconData icon;
  final bool directionStart;

  _DismissIndicator({this.icon, this.directionStart});

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
                directionStart == true
                    ? 'images/item_left.png'
                    : 'images/item_right.png',
                width: 45,
                height: 148)),
        Icon(icon ?? EasyIcons.arrow_left, size: 16, color: Colors.white)
      ]);
}
