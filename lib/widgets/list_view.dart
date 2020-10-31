import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/base_model.dart';
import 'package:easyhour_app/providers/base_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/header_content.dart';
import 'package:easyhour_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
import 'list_item.dart';

abstract class EasyListState<W extends StatefulWidget, T extends BaseModel,
        P extends BaseProvider> extends State<W>
    with AutomaticKeepAliveClientMixin {
  final String emptyText;
  final bool refreshEnabled;

  bool _loading = false;
  String _error;

  @protected
  String get defaultEmptyText => BaseModel.displayName(T).isNotEmpty
      ? LocaleKeys.empty_list_generic
          .tr(args: [BaseModel.displayName(T).plural(2).toLowerCase()])
      : "";

  EasyListState({this.emptyText, this.refreshEnabled = true});

  Widget getItem(int index, T item) => EasyListItem<T>(item,
      endIcon: EasyIcons.delete,
      endText: LocaleKeys.label_delete.tr(),
      onEdit: onEdit,
      onDelete: onDelete);

  @protected
  Comparator<T> comparator() => null;

  void fetchData() async {
    try {
      if (!mounted) return;
      setState(() {
        _error = null;
        _loading = true;
      });

      // Get the items
      await context.read<P>().get();

      if (!mounted) return;
      setState(() {
        _error = null;
        _loading = false;
      });
    } catch (e, s) {
      if (!mounted) return;
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
        return _EmptyList(
            text: _error ?? emptyText ?? defaultEmptyText,
            onRefresh: _onRefresh);
      }

      // Allow subclasses to sort items
      final items = List.of(provider.items);
      if (comparator() != null) items.sort(comparator());

      // All good, create the list
      final Widget listView = AnimationLimiter(
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: provider.items.length,
              itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: getItem(index, items[index]),
                    ),
                  )),
              separatorBuilder: (_, index) => SizedBox(height: 8)));

      // Show the list
      return refreshEnabled
          ? RefreshIndicator(onRefresh: _onRefresh, child: listView)
          : listView;
    });
  }

  Future<void> _onRefresh() async => fetchData();

  @protected
  void onEdit(T item) async {
    final result = EasyAppBar.pushNamed(
        context, EasyRoute.addEdit(item.runtimeType, arguments: () => item));

    // Show the result message
    if (result != null) showMessage(Scaffold.of(context), result);
  }

  @protected
  void onDelete(T item) async {
    try {
      // Delete the item
      bool result = await context.read<P>().delete(item);
      if (result) {
        showMessage(
            Scaffold.of(context), LocaleKeys.message_delete_generic.tr());
      }
    } catch (e, s) {
      handleRestError(context, e, s);
    }
  }

  @override
  get wantKeepAlive => true;
}

class _EmptyList extends StatelessWidget {
  final String text;
  final Function onRefresh;

  _EmptyList({@required this.text, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1;

    return FixedHeaderAndContent(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list, size: 128, color: textStyle.color),
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ],
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}
