import 'package:flutter/material.dart';
import 'package:flutterapp/api_management.dart';
import 'package:flutterapp/results_card.dart';
import 'package:flutterapp/utils/data.dart';
import 'package:flutterapp/utils/database.dart';

import 'date.dart';
import 'music_suggestions.dart';
import 'sentiment_score.dart';
import 'constants.dart';

class Music extends StatefulWidget {
  final String userInputText;

  Music({@required this.userInputText});

  @override
  MusicState createState() => MusicState();
}

class MusicState extends State<Music> {
  MusicSuggestions _suggestions;
  bool _loading;
  SentimentScore sentimentScore;
  MusicApi musicApi;

  @override
  void initState() {
    super.initState();
    _loading = true;
    sentimentScore = SentimentScore(widget.userInputText);
    musicApi = MusicApi(
        valence: sentimentScore.getValenceScore(),
        arousal: sentimentScore.getArousalScore());
    _initialLoad();
  }

  void _initialLoad() async {
    await musicApi.getSuggestions().then((suggestions) {
      setState(() {
        _suggestions = suggestions;
      });
    }).then((value) => setState(() {
          _loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _showDetails()));
  }

  Widget _showDetails() {
    if (_loading) {
      return CircularProgressIndicator();
    } else if (_suggestions.tracks.track.isEmpty) {
      return Text("No Suggestions to make, please try again later");
    } else {
      String songName = _suggestions.tracks.track[0].title;
      String artistName = _suggestions.tracks.track[0].artistDisplayName;
      String genre = _suggestions.tracks.track[0].genre;
      String releaseYear = _suggestions.tracks.track[0].releasedate;
      _updateDatabase(songName, artistName, genre, releaseYear);
      return Scaffold(
        body: ResultsCard(
          colour: kCardColour,
          artistName: artistName,
          genre: genre,
          releaseYear: releaseYear,
          songName: songName,
          onReturn: () => Navigator.pop(context),
        ),
      );
    }
  }

  void _updateDatabase(
      String songName, String artistName, String genre, String releaseYear) {
    DateTime currentTime = DateTime.now();
    int currentTimeToSave = Date(dateTime: currentTime).getDatabaseFormat();
    int valence = sentimentScore.getValenceScore();
    int arousal = sentimentScore.getArousalScore();
    List<String> pl = sentimentScore.getPositiveKeywords();
    List<String> nl = sentimentScore.getNegativeKeywords();
    List<String> keywordsToMerge = pl + nl;
    String mergedKeywords = "";
    for (int i = 0; i < keywordsToMerge.length; i++) {
      String toAddDivider = keywordsToMerge[i] + "|";
      mergedKeywords = mergedKeywords + toAddDivider;
    }

    Data dataToSave = Data(
      dateTime: currentTimeToSave,
      valenceScore: valence,
      arousalScore: arousal,
      keywords: mergedKeywords,
      songName: songName,
      artistName: artistName,
      genre: genre,
      releaseYear: releaseYear,
    );

    DBProvider.db.newData(dataToSave);
  }
}
