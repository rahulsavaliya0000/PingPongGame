import 'dart:async';
import 'package:flutter/material.dart';

//contact me for any modification EMAIL : rahulsavaiya0000@gmail.com

class PingPongCourt extends StatefulWidget {
  @override
  _PingPongCourtState createState() => _PingPongCourtState();
}

class _PingPongCourtState extends State<PingPongCourt> {
  static const double paddleWidth = 100.0;
  static const double paddleHeight = 30.0;
  static const double ballDiameter = 20.0;

  double paddlePosition = 0.0;
  double ballX = 0.0;
  double ballY = 0.0;
  double ballXSpeed = 3.0;
  double ballYSpeed = 3.0;
  int score = 0;
  bool hasHitPaddle = false; // Flag to track if the ball has hit the paddle

  late MediaQueryData mediaQueryData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mediaQueryData = MediaQuery.of(context);
  }

  @override
  void initState() {
    super.initState();
    startGame(); // Start the game loop
  }

  void startGame() {
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        ballX += ballXSpeed;
        ballY += ballYSpeed;

        // Increase ball speed continuously
        ballXSpeed += 0.01;
        ballYSpeed += 0.01;

        if (ballX <= 0 || ballX >= mediaQueryData.size.width - ballDiameter) {
          ballXSpeed *= -1;
        }

        if (ballY <= 0 ||
            (ballY >=
                    mediaQueryData.size.height - ballDiameter - paddleHeight &&
                ballX >= paddlePosition &&
                ballX <= paddlePosition + paddleWidth)) {
          if (!hasHitPaddle) {
            ballYSpeed *= -1;
            hasHitPaddle = true; // Set the flag to true
            if (ballY > 0) {
              score++; // Increase score when ball hits the paddle
            }
          }
        } else {
          hasHitPaddle =
              false; // Reset the flag if ball moves away from the paddle
        }

        if (ballY >= mediaQueryData.size.height - ballDiameter) {
          // Game over
          timer.cancel();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Game Over',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                  ),
                ),
                content: Text(
                  'Your score: $score',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: 25.0,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Do nothing or handle any other action on cancel
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        score = 0; // Reset the score
                        ballX = 0.0; // Reset ball position
                        ballY = 0.0;
                        ballXSpeed = 3.0; // Reset ball speed
                        ballYSpeed = 3.0;
                      });
                      // Restart game
                      startGame();
                    },
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          paddlePosition += details.delta.dx;
          if (paddlePosition < 0) {
            paddlePosition = 0;
          } else if (paddlePosition > mediaQueryData.size.width - paddleWidth) {
            paddlePosition = mediaQueryData.size.width - paddleWidth;
          }
        });
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned(
              left: ballX,
              top: ballY,
              child: Container(
                width: ballDiameter,
                height: ballDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow,
                      Colors.orange,
                    ],
                    stops: [0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: paddlePosition,
              bottom: 10,
              child: Container(
                width: paddleWidth,
                height: paddleHeight,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.orange.shade400,
                ),
              ),
            ),
            // Score display
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Text(
                  '$score',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: 170.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
