import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/base_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'list_item.dart';

abstract class EasyListState<T extends BaseModel, P extends BaseProvider>
    extends State with AutomaticKeepAliveClientMixin {
  final String emptyText;
  final bool refreshEnabled;

  bool _loading = false;
  String _error;

  @protected
  static String defaultEmptyText(String itemName) =>
      LocaleKeys.empty_list_generic
          .tr(args: [itemName.plural(2).toLowerCase()]);

  EasyListState(this.emptyText, {this.refreshEnabled = true});

  Widget getItem(T item) =>
      EasyListItem<T>(item, onEdit: onEdit, onDelete: onDelete);

  void fetchData() async {
    try {
      setState(() {
        _error = null;
        _loading = true;
      });

      // Get the items
      await context.read<P>().get();

      setState(() {
        _error = null;
        _loading = false;
      });
    } catch (e, s) {
      setState(() {
        _error = handleRestError(context, e, s);
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<P>(builder: (_, P provider, Widget child) {
      if (_loading) {
        // Show loader
        return EasyLoader();
      } else if (provider.items?.isEmpty ?? true) {
        // Show an empty list
        return _EmptyList(text: _error ?? emptyText, onRefresh: _onRefresh);
      }

      // All good, create the list
      final Widget listView = ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: provider.items.length,
          itemBuilder: (_, index) => getItem(provider.items[index]));

      // Show the list
      return refreshEnabled
          ? RefreshIndicator(onRefresh: _onRefresh, child: listView)
          : listView;
    });
  }

  Future<void> _onRefresh() async => fetchData();

  @protected
  void onEdit(T item) async {
    final result = await Navigator.pushNamed(
        context, (EasyRoute.addEdit(item.runtimeType)?.page),
        arguments: item);

    // Show the result message
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @protected
  void onDelete(T item) async {
    try {
      // Delete the item
      bool result = await context.read<P>().delete(item);
      if (result) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text(LocaleKeys.message_delete_generic.tr())));
      }
    } catch (e, s) {
      handleRestError(context, e, s);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _EmptyList extends StatelessWidget {
  final String text;
  final Function onRefresh;

  _EmptyList({@required this.text, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: <Widget>[
          ListView(),
          Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ))
        ],
      ),
    );
  }
}
