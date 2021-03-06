import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TelemetryForm extends StatefulWidget {
  TelemetryForm({Key key}) : super(key: key);

  @override
  _TelemetryFormState createState() => _TelemetryFormState();
}

class _TelemetryFormState extends State<TelemetryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Provider.of<RoastTelemetryModel>(context, listen: false)
                    .add(RoastMeasurement(new DateTime.now(), 0, 0, 0, 0));
              }
            },
            child: Text('Record',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            minWidth: double.infinity,
            color: Colors.brown,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Bean Temperature',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please record bean temperature';
              }
              final n = num.tryParse(value);
              if (n == null) {
                return '"$value" is not a valid number';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Environment Temperature',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please record bean temperature';
              }
              final n = num.tryParse(value);
              if (n == null) {
                return '"$value" is not a valid number';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Fan Speed',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please record bean temperature';
              }
              final n = num.tryParse(value);
              if (n == null) {
                return '"$value" is not a valid number';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Power',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please record bean temperature';
              }
              final n = num.tryParse(value);
              if (n == null) {
                return '"$value" is not a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class RoastMeasurement {
  DateTime timestamp;
  int environmentTemperature;
  int beanMassTemperature;
  int fan;
  int power;

  RoastMeasurement(this.timestamp, this.environmentTemperature,
      this.beanMassTemperature, this.fan, this.power);
}

class RoastTelemetryModel extends ChangeNotifier {
  final List<RoastMeasurement> _measurements = [];
  UnmodifiableListView<RoastMeasurement> get measurements =>
      UnmodifiableListView(_measurements);

  final Stopwatch _stopwatch = new Stopwatch();
  int _stage = 0;
  int firstCrack;
  int secondCrack;

  void add(RoastMeasurement measurement) {
    _measurements.add(measurement);
    notifyListeners();
  }

  void startRoast() {
    _stopwatch.start();
    notifyListeners();
  }

  void stopRoast() {
    _stopwatch.stop();
    notifyListeners();
  }

  void newRoast() {
    _stage = 0;
    _stopwatch.reset();
    notifyListeners();
  }

  bool roastInSession() {
    return _stopwatch.isRunning;
  }

  int roastTime() {
    return _stopwatch.elapsedMilliseconds;
  }

  void recordCrack() {
    if (!roastInSession() || hitSecondCrack()) return;
    if (hitFirstCrack()) {
      _stage = 2;
      secondCrack = _stopwatch.elapsedMilliseconds;
      print('second crack');
    } else {
      _stage = 1;
      firstCrack = _stopwatch.elapsedMilliseconds;
      print('first crack');
    }
    notifyListeners();
  }

  int developmentPercent() {
    if (!hitFirstCrack()) return 0;
    return (100*(_stopwatch.elapsedMilliseconds - firstCrack)) ~/
        (_stopwatch.elapsedMilliseconds);
  }

  void recordSecondCrack() {
    _stage = 2;
    secondCrack = _stopwatch.elapsedMilliseconds;
    notifyListeners();
  }

  bool hitFirstCrack() {
    return _stage > 0;
  }

  bool hitSecondCrack() {
    return _stage > 1;
  }
}
