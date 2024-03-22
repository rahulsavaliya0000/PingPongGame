import 'package:flutter/material.dart';
import 'package:stopwatch/pingpong_home.dart';

//contact me for any modification EMAIL : rahulsavaiya0000@gmail.com

void main() => runApp(PingPongGame());

class PingPongGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PingPongCourt(),
      ),
    );
  }
}
