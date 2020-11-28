import 'package:croast/roast_telemetry.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class TimerWidget extends StatefulWidget {
  TimerWidget({Key key}) : super(key: key);

  TimerWidgetState createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];

  @override
  Widget build(BuildContext context) {
    return new TimerText(timerListeners: timerListeners);
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;

  TimerTextState createState() =>
      new TimerTextState(timerListeners: timerListeners);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds !=
        Provider.of<RoastTelemetryModel>(context, listen: false).roastTime()) {
      milliseconds =
          Provider.of<RoastTelemetryModel>(context, listen: false).roastTime();
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in this.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new MinutesAndSeconds(timerListeners: this.timerListeners),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new Hundreds(timerListeners: this.timerListeners),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(timerListeners: timerListeners);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    this.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.',
        style: TextStyle(fontSize: 70.0));
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;

  HundredsState createState() =>
      new HundredsState(timerListeners: timerListeners);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.timerListeners});
  final List<ValueChanged<ElapsedTime>> timerListeners;

  int hundreds = 0;

  @override
  void initState() {
    this.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: TextStyle(fontSize: 70.0));
  }
}
