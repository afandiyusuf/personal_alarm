import 'dart:convert';
import 'dart:ffi';

import 'package:personal_alarm/core/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService{
  final String alarmKey  = "ALARM";

  saveAlarm(List<Alarm> alarms)async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.setString(alarmKey, json.encode(alarms));
  }
  Future<List<Alarm>> getAlarm() async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    String? alarmString = p.getString(alarmKey);
    if(alarmString != null){
      var jsonData = jsonDecode(alarmString);
      return List<Alarm>.from(jsonData.map((e){
        print(e);
        return Alarm.fromJson(e);
      }));
    }
    return [];
  }

  deleteAlarmId(int id) async {
    List<Alarm> _alarms = await getAlarm();
    _alarms.removeWhere((element) => element.id == id);
    await saveAlarm(_alarms);
  }
}