import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  SettingsButton({@required this.onPressed, @required this.text});

  final GestureTapCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        padding: EdgeInsets.all(16.0),
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            SizedBox(
              width: 24.0,
            ),
            Text(text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ))
          ],
        ),
      ),
    );
  }
}
