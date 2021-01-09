import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage({@required this.testWidget});

  final Widget testWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Moodsicle',
          style: kSubLabelTextStyle,
        ),
      ),
      body: testWidget,
    );
  }
}
