import 'package:flutter/cupertino.dart';

class EasyDurationPicker extends StatefulWidget {
  Duration get value => _value;
  Duration _value;

  EasyDurationPicker(this._value);

  @override
  State<StatefulWidget> createState() => _EasyDurationPickerState();
}

class _EasyDurationPickerState extends State<EasyDurationPicker> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 5,
      initialTimerDuration: widget._value,
      onTimerDurationChanged: (Duration value) {
        setState(() {
          widget._value = value;
        });
      },
    );
  }
}
