import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class EasyListItem<T extends BaseModel> extends StatelessWidget {
  final BaseModel item;

  final ConfirmDismissCallback confirmDismiss;
  final DismissDirectionCallback onDismissed;
  final IconData startIcon;
  final IconData endIcon;

  final Function(T) onEdit;
  final Function(T) onDelete;

  EasyListItem(this.item,
      {this.onEdit,
      this.onDelete,
      this.startIcon,
      this.endIcon,
      this.confirmDismiss,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    if (item.dismissible && item.editable) {
      return _DismissibleEasyListItem<T>(item,
          bothDirections: startIcon != null,
          confirmDismiss: confirmDismiss,
          onDismissed: onDismissed,
          child: _EditableEasyListItem<T>(item,
              child:
                  _EasyListItem(item, startIcon: startIcon, endIcon: endIcon),
              onEdit: onEdit),
          onDelete: onDelete);
    } else if (item.dismissible) {
      return _DismissibleEasyListItem<T>(item,
          bothDirections: startIcon != null,
          confirmDismiss: confirmDismiss,
          onDismissed: onDismissed,
          child: _ReadonlyEasyListItem(item,
              child:
                  _EasyListItem(item, startIcon: startIcon, endIcon: endIcon)),
          onDelete: onDelete);
    } else if (item.editable) {
      return _EditableEasyListItem<T>(item,
          child: _EasyListItem(item), onEdit: onEdit);
    }
    return _EasyListItem(item);
  }
}

class _DismissibleEasyListItem<T extends BaseModel> extends StatelessWidget {
  final BaseModel item;
  final Widget child;

  final ConfirmDismissCallback confirmDismiss;
  final DismissDirectionCallback onDismissed;
  final bool bothDirections;

  final Function(T) onDelete;

  _DismissibleEasyListItem(this.item,
      {@required this.child,
      @required this.onDelete,
      this.bothDirections,
      this.confirmDismiss,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(item.id),
        direction: item.dismissible != null
            ? bothDirections == true
                ? DismissDirection.horizontal
                : DismissDirection.endToStart
            : null,
        background: Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(EasyIcons.delete, color: Colors.white)),
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
}

class _EditableEasyListItem<T extends BaseModel> extends StatelessWidget {
  final BaseModel item;
  final Widget child;

  final Function(T) onEdit;

  _EditableEasyListItem(this.item,
      {@required this.child, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(child: InkWell(onTap: () => onEdit(item), child: child));
  }
}

class _ReadonlyEasyListItem extends StatelessWidget {
  final BaseModel item;
  final Widget child;

  _ReadonlyEasyListItem(this.item, {@required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(child: child);
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
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(item.listDetailsTop ?? "",
              style: Theme.of(context).textTheme.bodyText2),
          SizedBox(height: 8),
          Text(item.listDetailsBtm ?? "",
              style: Theme.of(context).textTheme.bodyText2)
        ]),
        SizedBox(width: 16),
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
