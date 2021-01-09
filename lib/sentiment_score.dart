import 'package:sentiment_dart/sentiment_dart.dart';

class SentimentScore {
  String text;
  Map<String, dynamic> analysis;

  SentimentScore(String text) {
    this.text = text;
    final sentiment = Sentiment();
    analysis = sentiment.analysis(text);
  }

  /// Return valence score from 0 - 1,000000
  /// 500,000 is the neutral score
  int getValenceScore() {
    int tokensLength = analysis["words"].length;
    double valenceScore =
        500000 + (analysis["score"] / (tokensLength * 5)) * 500000;
    return valenceScore.round();
  }

  /// Return Arousal score from 0 - 1,000000
  /// 0 is the neutral score
  int getArousalScore() {
    double comparative = analysis["comparative"];
    if (comparative < 0) {
      comparative *= -1;
    }
    return (comparative * 200000).round();
  }

  List<String> getPositiveKeywords() {
    List<dynamic> l =  analysis["good words"];
    List<String> results = [];
    l.forEach((element) {
      results.add(element[0].toString());
    });
    return results;
  }

  List<String> getNegativeKeywords() {
    List<dynamic> l = analysis["badword"];
    List<String> results = [];
    l.forEach((element) {
      results.add(element[0].toString());
    });
    return results;
  }


  List<String> getTokens() {
    return analysis["words"];
  }
}
