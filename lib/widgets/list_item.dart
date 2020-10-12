import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class EasyListItem<T extends BaseModel> extends StatelessWidget {
  final BaseModel item;

  final Function(T) onEdit;
  final Function(T) onDelete;

  EasyListItem(this.item, {this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (item.dismissible && item.editable) {
      return _DismissibleEasyListItem<T>(item,
          child: _EditableEasyListItem<T>(item,
              child: _EasyListItem(item), onEdit: onEdit),
          onDelete: onDelete);
    } else if (item.dismissible) {
      return _DismissibleEasyListItem<T>(item,
          child: _ReadonlyEasyListItem(item, child: _EasyListItem(item)),
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

  final Function(T) onDelete;

  _DismissibleEasyListItem(this.item,
      {@required this.child, @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(item.id),
        direction:
            item.dismissible != null ? DismissDirection.endToStart : null,
        background: Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(EasyIcons.delete, color: Colors.white)),
        confirmDismiss: (DismissDirection direction) async =>
            await showConfirmDeleteDialog(
                context,
                LocaleKeys.message_delete_confirm
                    .tr(args: [item.listTitle.toLowerCase()])),
        onDismissed: (_) => onDelete(item),
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

  _EasyListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                        maxLines: 1,
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
        if (item.approved != null)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(item.approved ? Icons.check : Icons.hourglass_empty,
                color: Theme.of(context).primaryColor),
          ),
        Container(
          height: 100,
          child: item.dismissible ? _DismissIndicator() : null,
        ),
      ],
    );
  }
}

class _DismissIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        FittedBox(
            fit: BoxFit.contain,
            child:
                Image.asset('images/item_right.png', width: 45, height: 148)),
        Icon(EasyIcons.arrow_left, size: 16, color: Colors.white)
      ]);
}
