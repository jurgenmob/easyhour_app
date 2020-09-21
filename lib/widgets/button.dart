import 'package:flutter/material.dart';

class EasyButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  EasyButton({@required this.text, this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, color: Colors.white),
                if (icon != null) SizedBox(width: 16),
                Text(
                  text.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            color: Theme.of(context).primaryColor,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
