import 'package:flutter/material.dart';

class EasyLoader extends StatelessWidget {
  final Color color;
  final bool showLogo;

  EasyLoader({this.color, this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLogo)
            Container(
              padding: EdgeInsets.all(48),
              child: Image.asset(
                'images/logo_or.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                valueColor:
                    color != null ? AlwaysStoppedAnimation<Color>(color) : null,
              )),
        ],
      ),
    );
  }
}
