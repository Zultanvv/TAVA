import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class VoiceControlScreen extends StatefulWidget {
  @override
  _VoiceControlScreenState createState() => _VoiceControlScreenState();
  
}

class _VoiceControlScreenState extends State<VoiceControlScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Interpreter? _interpreter;
  String _text = 'Press the button and start speaking';
  String _identifiedSpeaker = '';
  var _model = 'assets/models/tes.tflite';
  List<String> labels = ['fajar', 'herlambang', 'zultan'];
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _initInterpreter(); // Initialize TensorFlow Lite interpreter
    _speech = stt.SpeechToText();
  }

  Future<void> _initInterpreter() async {
    try {

  var interpreter = await Interpreter.fromAsset(
    'assets/tes.tflite');
    print('interpreter succes');
} catch (e) {
  print('Error while creating interpreter: $e');
}
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
        },
        onError: (val) {
          print('onError: $val');
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) async {
            setState(() {
              _text = val.recognizedWords;
            });

            print('Recognized words: $_text');

            // Handle recognized commands
            if (_text.toLowerCase().contains("open one")) {
              _updateFirebaseLed1('0');
            } else if (_text.toLowerCase().contains("close one")) {
              _updateFirebaseLed1('1');
            } else if (_text.toLowerCase().contains("open light")) {
              _updateFirebaseLed2('0');
            } else if (_text.toLowerCase().contains("close light")) {
              _updateFirebaseLed2('1');
            } else if (_text.toLowerCase().contains("open air")) {
              _updateFirebaseKipas('0');
            } else if (_text.toLowerCase().contains("close air")) {
              _updateFirebaseKipas('1');
            } else {
              _unrecognizedCommand();
            }

            // Perform voice authentication using TensorFlow Lite
            var features = extractAudioFeatures(_text);
            if (features.isNotEmpty) {
              print('Extracted features: $features');
              var input_shape = [features];
              print('Input tensor: $input_shape');

              var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
              print('Initialized output: $output');

              try {
                _interpreter?.run(input_shape, output);
                print('Output after run: $output');

                var result = output[0];
                print('Result final: $result');
                var maxIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));
                var identifiedLabel = labels[maxIndex];

                setState(() {
                  _identifiedSpeaker = 'Speaker Identified: $identifiedLabel';
                });

                print('Authentication successful, identified speaker: $identifiedLabel');
              } catch (e) {
                print('Error running interpreter: $e');
                setState(() {
                  _identifiedSpeaker = 'Authentication failed';
                });
              }
            } else {
              print('Failed to extract features from audio');
              setState(() {
                _identifiedSpeaker = 'Authentication failed';
              });
            }
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _updateFirebaseLed1(String value) {
    databaseReference.child('led-db/led_1').set(value).then((_) {
      print('led_1 updated successfully in Firebase.');
    }).catchError((error) {
      print('Failed to update led_1: $error');
    });
  }

  void _updateFirebaseLed2(String value) {
    databaseReference.child('led-db/led_2').set(value).then((_) {
      print('led_2 updated successfully in Firebase.');
    }).catchError((error) {
      print('Failed to update led_2: $error');
    });
  }

  void _updateFirebaseKipas(String value) {
    databaseReference.child('led-db/kipas').set(value).then((_) {
      print('kipas updated successfully in Firebase.');
    }).catchError((error) {
      print('Failed to update kipas: $error');
    });
  }

  void _unrecognizedCommand() {
    print('Unknown command received.');
  }

  List<double> extractAudioFeatures(String speechText) {
    List<double> features = [];

    for (int i = 0; i < speechText.length; i++) {
      features.add(speechText.codeUnitAt(i).toDouble());
    }

    print('Extracted features from speech text: $features');
    return features;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_text',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              '$_identifiedSpeaker',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ],
        ),
      ),
    );
  }
}