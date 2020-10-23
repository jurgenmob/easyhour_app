import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/data/rest_client.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/globals.dart';
import 'package:easyhour_app/models/request.dart';
import 'package:easyhour_app/providers/request_provider.dart';
import 'package:easyhour_app/routes.dart';
import 'package:easyhour_app/screens/base_screen.dart';
import 'package:easyhour_app/theme.dart';
import 'package:easyhour_app/widgets/list_item.dart';
import 'package:easyhour_app/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestListScreen extends BaseScreen<Request> {
  @override
  List<EasyRoute> getAppBarRoutes(BuildContext context) => null;

  @override
  Widget getBody() => _RequestListScreen();
}

class _RequestListScreen extends StatefulWidget {
  @override
  createState() => _RequestListScreenState();
}

class _RequestListScreenState
    extends EasyListState<_RequestListScreen, Request, RequestProvider> {
  _RequestListScreenState()
      : super(emptyText: LocaleKeys.message_no_requests.tr());

  @override
  Widget getItem(Request item) => EasyListItem<Request>(item,
      startIcon: EasyIcons.approve_ok,
      startText: LocaleKeys.label_approve.tr(),
      endIcon: EasyIcons.approve_ko,
      endText: LocaleKeys.label_refuse.tr(),
      confirmDismiss: (direction) => Future.value(true),
      onDismissed: (direction) => _approveRefuse(item, direction),
      onEdit: (_) {
        _showDescr(item);
      });

  void _approveRefuse(Request item, DismissDirection direction) async {
    try {
      final approved = direction == DismissDirection.startToEnd;
      await context
          .read<RequestProvider>()
          .approveRefuse(item, approved: approved);

      // Show the result
      showMessage(
          Scaffold.of(context),
          (approved
                  ? LocaleKeys.message_request_approved
                  : LocaleKeys.message_request_refused)
              .tr(args: [item.tipologia.toLowerCase()]));
    } catch (e, s) {
      handleRestError(context, e, s);
    }
  }

  void _showDescr(Request item) {
    // Show the details
    showMessage(
        Scaffold.of(context),
        item.descrizione?.isNotEmpty == true
            ? item.descrizione
            : LocaleKeys.message_no_description.tr());
  }
}
