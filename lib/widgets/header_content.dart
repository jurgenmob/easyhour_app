import 'package:flutter/material.dart';

class FixedHeaderAndContent extends StatelessWidget {
  final Widget header;
  final Widget content;
  final RefreshCallback onRefresh;

  const FixedHeaderAndContent(
      {Key key, @required this.header, @required this.content, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return onRefresh != null
          ? RefreshIndicator(
              onRefresh: onRefresh, child: _build(context, constraints))
          : _build(context, constraints);
    });
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              header,
              Expanded(
                child: Container(
                  height: 0,
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
