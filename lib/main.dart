import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountdownApp(),
    );
  }
}

class CountdownApp extends StatefulWidget {
  @override
  _CountdownAppState createState() => _CountdownAppState();
}

class _CountdownAppState extends State<CountdownApp> {
  int countdown = 10;
  bool isCountingDown = false;
  Timer? countdownTimer; // Define countdownTimer here

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('logo3');
    var initializationSettingsIOS = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startCountdown() {
    setState(() {
      countdown = 10; // Reset the countdown value
      isCountingDown = true;
    });

    if (countdownTimer != null) {
      countdownTimer!.cancel(); // Cancel the previous timer if it exists
    }

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;

        if (countdown == 0) {
          timer.cancel(); // Stop the countdown timer
          showFinalNotification();
          setState(() {
            isCountingDown = false;
          });
        }
      });
    });
  }

  // Function to show the final notification
  Future<void> showFinalNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Countdown Notification',
      'Final notification after 10 seconds',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void cancelCountdown() {
    setState(() {
      countdown = 10;
      isCountingDown = false;
    });

    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel(); // Cancel the countdown timer if it's active
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Countdown App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: isCountingDown ? null : startCountdown,
              child: Text('Start Countdown'),
            ),
            SizedBox(height: 20),
            Text(
              'Time remaining: $countdown seconds',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: isCountingDown ? cancelCountdown : null,
              child: Text('Cancel Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
