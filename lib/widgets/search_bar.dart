import 'package:easy_localization/easy_localization.dart';
import 'package:easyhour_app/providers/base_provider.dart';
import 'package:easyhour_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';

class EasySearchBar<P extends BaseProvider> extends StatefulWidget {
  @override
  _EasySearchBarState createState() => _EasySearchBarState<P>();
}

class _EasySearchBarState<P extends BaseProvider>
    extends State<EasySearchBar<P>> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      Provider.of<P>(context, listen: false).filter = _controller.text;
      setState(() {});
    });

    return Container(
      color: Color(0xFFF2F2F2),
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
