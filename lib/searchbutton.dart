import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    @required this.onPressed,
  });

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: kBottomContainerColour,
      splashColor: Color(0x6669F0AE),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.music_note,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Search',
              maxLines: 1,
              style: kSearchButtonTextStyle,
            ),
            SizedBox(
              width: 10.0,
            ),
            Icon(
              Icons.music_note,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
