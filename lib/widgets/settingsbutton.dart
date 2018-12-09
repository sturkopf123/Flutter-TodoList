import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  SettingsButton({@required this.onPressed, @required this.text, this.icon});

  final GestureTapCallback onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        padding: EdgeInsets.all(16.0),
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(text,
                  style: TextStyle(
                    fontSize: 16.0,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
