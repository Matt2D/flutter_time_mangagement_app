import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'src/storage.dart';


void main() async{
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? countdownTimer;
  Duration dur = const Duration(hours: 0);
  String currAct = "Nothing";

  Activity work = Activity("Work");
  Activity sleep = Activity("Sleep");
  Activity entertainment = Activity("Entertainment");

  Activity currA = Activity("Nothing");

  void _startTimer(){
    if(dur.inSeconds == 0) {
      dur = currA.retTime();
    }
    if(countdownTimer == null || !countdownTimer!.isActive){
      countdownTimer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown(currA));
    }
  }

  void setCountDown(Activity a) {
    final reduceSecondsBy = 1;
    int seconds = a.retTime().inSeconds;
    setState(() {
      seconds = dur.inSeconds + reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        dur = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void saveTime(){
    setState(() {
      currA.addTime(dur - currA.totalDur);
    });

  }

  void resetTimer(Duration d) {
    stopTimer();
    setState(() => dur = d);
  }

  void setActivity(Activity activity)
  {
    saveTime();
    setState(() => currA = activity);
    setState(() => currAct = activity.getName());
    setState(() => dur = activity.totalDur);
    setState(() {
      if (!currA.equals(activity)){
        resetTimer(activity.retTime());
      }
    });
    resetTimer(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(dur.inHours.remainder(24));
    final minutes = strDigits(dur.inMinutes.remainder(60));
    final seconds = strDigits(dur.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Management"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Current Activity:$currAct",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ],
            ),
            Text(
              "$hours:$minutes:$seconds",
              style: TextStyle(
                fontSize: 50
              ),
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: _startTimer,
                    child: Text("Start")
                  ),
                  FilledButton(
                      onPressed: stopTimer,
                      child: Text("Stop")
                  ),
                  FilledButton(
                      onPressed: () => resetTimer(Duration(seconds: 0)),
                      child: Text("Reset")
                  ),
                  FilledButton(
                      onPressed: saveTime,
                      child: Text("Save")
                  )
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      ElevatedButton(
                          onPressed: () => setActivity(work),
                          child: Text("Work")
                      ),
                        Text(work.strTime(),

                        ),
                      ],
                    ),
                    Row(
                      children: [
                      ElevatedButton(
                          onPressed: () => setActivity(sleep),
                          child: Text("Sleep")
                      ),
                        Text(sleep.strTime()
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                            onPressed: () => setActivity(entertainment),
                            child: Text("Entertainment")
                        ),
                        Text(entertainment.strTime())
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}