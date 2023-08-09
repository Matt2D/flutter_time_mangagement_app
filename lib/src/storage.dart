import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Activity{

  Duration totalDur = Duration(seconds: 0);
  String name = "";

  Activity(String n){
    name = n;
  }

  String getName(){
    return name;
  }

  void addTime(Duration d){
    totalDur = totalDur + d;
  }

  Duration retTime(){
    return totalDur;
  }

  String strTime(){
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    final hours = strDigits(totalDur.inHours.remainder(24));
    final minutes = strDigits(totalDur.inMinutes.remainder(60));
    final seconds = strDigits(totalDur.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  bool equals(Activity b){
    return this.name == b.name;
  }

}
