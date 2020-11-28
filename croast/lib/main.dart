import 'package:croast/percent_widget.dart';
import 'package:croast/roast_controls.dart';
import 'package:croast/roast_telemetry.dart';
import 'package:croast/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => RoastTelemetryModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fresh Roast Logging Tool'),
        ),
        body: Center(
            child: Column(
          children: [
            Row(children: [TimerWidget(), DevelopmentWidget()],  mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            TelemetryForm(),
            RoastControls(),
            Consumer<RoastTelemetryModel>(builder: (context, telemetry, child) {
              return Text(
                  "Meansurements measurments: ${telemetry.measurements}");
            }),
          ],
        )),
      ),
    );
  }
}

