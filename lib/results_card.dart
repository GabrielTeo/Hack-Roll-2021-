import 'package:flutter/material.dart';
import 'package:flutterapp/display_card.dart';
import 'bottom_button.dart';
import 'constants.dart';

class ResultsCard extends StatelessWidget {
  ResultsCard(
      {@required this.colour,
      this.onPress,
      this.onReturn,
      this.songName = "",
      this.artistName = "",
      this.genre = "",
      this.releaseYear = ""});

  final Color colour;
  final Function onPress;
  final String songName;
  final String artistName;
  final String genre;
  final String releaseYear;
  final Function onReturn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Here are your music suggestions',
                  style: kBodyTextStyle,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: DisplayCard(
                colour: kCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      artistName.toUpperCase(),
                      style: kResultTextStyle,
                    ),
                    Text(
                      songName,
                      style: kSongTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          genre,
                          textAlign: TextAlign.center,
                          style: kBodyTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          releaseYear,
                          textAlign: TextAlign.center,
                          style: kBodyTextStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BottomButton(buttonTitle: 'TRY A DIFFERENT MOOD', onTap: onReturn)
          ],
        ),
      ),
    );
  }
}
