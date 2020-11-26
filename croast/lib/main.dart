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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fresh Roast Logging Tool'),
        ),
        body: Center(
            child: Column(
          children: [
            TimerPage(),
            TelemetryForm(),
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

class AddButton extends StatelessWidget {
  // const _AddButton({Key key, @required this.measurement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.

    return FlatButton(
      onPressed: () {
        final RoastMeasurement measurement =
            RoastMeasurement(new DateTime.now(), 0, 0, 0, 0);
        // If the item is not in cart, we let the user add it.
        // We are using context.read() here because the callback
        // is executed whenever the user taps the button. In other
        // words, it is executed outside the build method.
        Provider.of<RoastTelemetryModel>(context, listen: false)
            .add(measurement);
      },
      splashColor: Theme.of(context).primaryColor,
      child: Text('ADD'),
    );
  }
}
