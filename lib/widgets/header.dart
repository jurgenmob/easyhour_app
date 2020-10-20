import 'package:flutter/material.dart';

class EasyHeader extends StatelessWidget {
  final String title;

  EasyHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
            padding: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3)),
      ),
    ]);
  }
}
