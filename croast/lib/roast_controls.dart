import 'package:croast/roast_telemetry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RoastControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RoastTelemetryModel rtm = Provider.of<RoastTelemetryModel>(context);

    String rightButtonText;
    if (!rtm.roastInSession()) {
      rightButtonText = "New Roast";
    } else if (!rtm.hitFirstCrack()) {
      rightButtonText = "Record First Crack";
    } else {
      rightButtonText = "Record Second Crack";
    }

    return Row(children: [
      FlatButton(
          onPressed: () {
            if (rtm.roastInSession())
              rtm.stopRoast();
            else
              rtm.startRoast();
          },
          child: new Text(rtm.roastInSession() ? "Stop Roast" : "Start Roast")),
      FlatButton(
        onPressed: () {
          if (rtm.roastInSession())
            rtm.recordCrack();
          else
            rtm.newRoast();
        },
        child: new Text(rightButtonText),
      )
    ]);
  }
}
