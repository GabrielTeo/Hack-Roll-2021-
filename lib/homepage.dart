import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/music_api.dart';
import 'package:flutterapp/results_page.dart';
import 'searchbutton.dart';
import 'time_display.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// This is the page when you click 'HOME'

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Moodsicle',
          style: kLabelTextStyle,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/home_background_1.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Time(),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'How are you feeling today?',
                      style: kBodyTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        style: kTextFieldStyle,
                        textAlign: TextAlign.center,
                        controller: textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          hintText: 'Tell us!',
                          hintStyle: kTextFieldStyle,
                        ),
                        cursorColor: kCursorColour,
                      ),
                    ),
                    AvatarGlow(
                      animate: _isListening,
                      glowColor: Theme.of(context).primaryColor,
                      endRadius: 30.0,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      child: FlatButton(
                        color: kMicBackgroundColour,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: kCursorColour,
                            width: 2.0,
                          ),
                        ),
                        onPressed: _listen,
                        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () {
                  if (textController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: kAlertDialogColour,
                          title: Text(
                            'Please enter some text!',
                            style: kAlertDialogTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          content: Image(
                            image: AssetImage('images/cat.gif'),
                          ),
                          elevation: 24.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    String _data = textController.text;
                    textController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(
                          testWidget: Music(
                            userInputText: _data,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(onStatus: (val) {
        if (val == 'notListening') {
          _isListening = false;
        }
      });
      if (available && mounted) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            textController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => {_isListening = false});
      _speech.stop();
    }
  }
}
