import 'dart:convert';

import 'package:personal_alarm/core/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService{
  final String alarmKey  = "ALARM";

  void saveAlarm(List<Alarm> alarms)async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    p.setStringList(alarmKey, List<String>.from(alarms.map((e) => e.toString())));
  }
  Future<List<Alarm>> getAlarm() async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    List<String> alarmStringList = p.getStringList(alarmKey)??[];
    return List<Alarm>.from(alarmStringList.map((e) => Alarm.fromJson(jsonDecode(e))));
  }
}