import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:personal_alarm/core/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class SharedPrefService{
  final String alarmKey  = "ALARM";
  final String alarmLatestId = "ALARM_LATEST_ID";
  DateTime? latestAlarm;
  Future<Alarm?> getLatestAlarm() async {
    String? _id = await getLatestAlarmId();
    if(_id != null){
      int _intId = int.parse(_id).toUnsigned(32);
      Alarm? _alarm = await getAlarmById(_intId);
      return _alarm;
    }
    return null;
  }

  saveLatestAlarmId(int id) async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    log("latest alarm id created $id");
    await p.setString(alarmLatestId, id.toUnsigned(32).toString());
  }

  Future<String?> getLatestAlarmId() async {
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    return p.getString(alarmLatestId);
  }

  saveAlarm(List<Alarm> alarms)async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.setString(alarmKey, json.encode(alarms));
    await updateLatestAlarm();
  }

  updateLatestAlarm() async {
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    List<Alarm> alarms = await getAlarm();
    if(alarms.isEmpty){
      log("Alarm is empty deleted all");
      p.remove(alarmKey);
      return;
    }
    Duration _d = Duration(hours: 100);
    Alarm _latestAlarm = alarms[0];
    DateTime _n = DateTime.now();
    for (var element in alarms) {
      Duration _tempDuration = _n.difference(element.alarmAt);
      if(_d > _tempDuration){
        _latestAlarm = element;
        _d = _tempDuration;
        log("latest alarm updated ${element.toString()}");
      }
    }

    await saveLatestAlarmId(_latestAlarm.id);
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
    log("Before delete ${_alarms.length}");
    _alarms.removeWhere((element) => element.id.toUnsigned(32) == id.toUnsigned(32));
    log("After delete ${_alarms.length}");
    await saveAlarm(_alarms);
  }
  deleteLatestAlarm() async {
    log("Deleting");
    Alarm? _alarm = await getLatestAlarm();
    if(_alarm != null){
      log("Deleting ${_alarm.toString()}");
      await deleteAlarmId(_alarm.id.toUnsigned(32));
      await updateLatestAlarm();
    }else{
      log("Null");
    }
  }

  Future<Alarm?> getAlarmById(int id) async {
    List<Alarm> _alarms = await getAlarm();
    Alarm? _a = _alarms.firstWhereOrNull((e) => e.id.toUnsigned(32) == id.toUnsigned(32));
    return _a;
  }
}