import 'package:flutter/material.dart';

class EasyLoader extends StatelessWidget {
  final Color color;

  EasyLoader({this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            valueColor:
                color != null ? new AlwaysStoppedAnimation<Color>(color) : null,
          )),
    );
  }
}
