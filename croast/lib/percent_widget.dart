import 'dart:async';

import 'package:croast/roast_telemetry.dart';
import 'package:flutter/material.dart';

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

class DevelopmentWidget extends StatefulWidget {
  DevelopmentWidget({Key key}) : super(key: key);

  DevelopmentWidgetState createState() => new DevelopmentWidgetState();
}

class DevelopmentWidgetState extends State<DevelopmentWidget> {

 int developmentPercent;

@override
  void initState() {
     super.initState();
     Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final RoastTelemetryModel rtm = Provider.of<RoastTelemetryModel>(context, listen: true);
    return Text('${rtm.developmentPercent()}%', style: TextStyle(fontSize: 70.0));
  }
}
