import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/generated/locale_keys.g.dart';
import 'package:easyhour_app/providers/base_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

class EasySearchBar<P extends BaseProvider> extends StatefulWidget {
  @override
  _EasySearchBarState createState() => _EasySearchBarState<P>();
}

class _EasySearchBarState<P extends BaseProvider>
    extends State<EasySearchBar<P>> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      if (!visible) FocusScope.of(context).unfocus();
    });

    _controller.addListener(() {
      context.read<P>().filter = _controller.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      margin: EdgeInsets.all(16),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: LocaleKeys.label_search.tr(),
          prefixIcon: Icon(EasyIcons.search),
          suffixIcon: _controller.text.length > 0
              ? IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                )
              : null,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
