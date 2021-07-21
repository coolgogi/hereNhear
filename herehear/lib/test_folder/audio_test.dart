import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
 final player = AudioCache();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(onPressed: () => player.play('assets/audio/loveRain.mp3'), child: Text('click'),),

    );
  }
}