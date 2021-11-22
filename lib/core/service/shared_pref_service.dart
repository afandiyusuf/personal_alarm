import 'dart:convert';

import 'package:personal_alarm/core/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService{
  final String alarmKey  = "ALARM";

  saveAlarm(List<Alarm> alarms)async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.setStringList(alarmKey, List<String>.from(alarms.map((e) => e.toString())));
  }
  Future<List<Alarm>> getAlarm() async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    List<String> alarmStringList = p.getStringList(alarmKey)??[];
    return List<Alarm>.from(alarmStringList.map((e) => Alarm.fromJson(jsonDecode(e))));
  }
}