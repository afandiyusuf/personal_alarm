import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:personal_alarm/core/model/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SharedPrefService{
  final String alarmKey  = "ALARM";
  final String alarmLatestIdKey = "ALARM_LATEST_ID";
  final String alarmResponseDataKey = "ALARM_RESPONSE_DATA";
  final String tempLatestAlarmIdKey = "TEMP_LATEST_ALARM_ID_KEY";

  saveLatestTempAlarmId(int? id) async {
    var pref = await SharedPreferences.getInstance();
    await pref.reload();
    if(id!=null) {
      await pref.setInt(tempLatestAlarmIdKey, id);
    }else{
      await pref.remove(tempLatestAlarmIdKey);
    }
  }
  Future<int?> getTempLatestAlarmId() async {
    var pref = await SharedPreferences.getInstance();
    await pref.reload();
    return pref.getInt(tempLatestAlarmIdKey);
  }


  DateTime? latestAlarm;
  Future<Alarm?> getLatestAlarm() async {
    String? _id = await getLatestAlarmId();
    if(_id != ''){
      int _intId = int.parse(_id).toUnsigned(32);
      Alarm? _alarm = await getAlarmById(_intId);
      return _alarm;
    }
    return null;
  }

  saveLatestAlarmId(int id) async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.reload();
    log("latest alarm id created $id");
    await p.setString(alarmLatestIdKey, id.toUnsigned(32).toString());
  }

  Future<String> getLatestAlarmId() async {
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.reload();
    return p.getString(alarmLatestIdKey)??'';
  }

  saveAlarm(List<Alarm> alarms)async{
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.reload();
    await p.setString(alarmKey, json.encode(alarms));
    await updateLatestAlarm();
  }

  updateLatestAlarm() async {
    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.reload();
    List<Alarm> alarms = await getAlarm();
    if(alarms.isEmpty){
      log("Alarm is empty deleted all");
      p.remove(alarmKey);
      return;
    }
    Duration _d = Duration(hours: 100);
    Alarm _latestAlarm = alarms[0];

    for (var element in alarms) {
      DateTime _n = DateTime.now();
      Duration _tempDuration = _n.difference(element.alarmAt).abs();
      log("_d is ${_d.inSeconds}");
      log("_tepmDuration is ${_tempDuration.inSeconds}");
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
    await p.reload();
    String alarmString = p.getString(alarmKey)??'';
    if(alarmString != ''){
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

  //this is for delete after its alarmTriggered
  deleteLatestAlarmAfterTriggered() async {
    log("Deleting");
    Alarm? _alarm = await getLatestAlarm();
    if(_alarm != null){
      saveLatestTempAlarmId(_alarm.id.toUnsigned(32));
      log("Deleting ${_alarm.toString()}");
      await _saveResponseDataAlarm(_alarm); //save to the response array pref
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

  _saveResponseDataAlarm(Alarm _alarm) async {

    var pref = SharedPreferences.getInstance();
    var p = await pref;
    await p.reload();
    String alarmString = p.getString(alarmResponseDataKey)??'';
    List<Alarm> alarmResponses = [];
    if(alarmString != ''){
      var jsonData = jsonDecode(alarmString);
      alarmResponses = List<Alarm>.from(jsonData.map((e){
        return Alarm.fromJson(e);
      }));
    }
    alarmResponses.add(_alarm);
    await p.reload();
    await p.setString(alarmResponseDataKey, json.encode(alarmResponses));
  }
  setResponseTimeAlarm(int id) async {
    tz.initializeTimeZones();
    var pref = await SharedPreferences.getInstance();
    await pref.reload();
    String alarmString = pref.getString(alarmResponseDataKey)??'';
    List<Alarm> alarmResponses = [];
    if(alarmString != ''){
      var jsonData = jsonDecode(alarmString);
      alarmResponses = List<Alarm>.from(jsonData.map((e){
        return Alarm.fromJson(e);
      }));
    }

    //get alarm by id
    for(var i =0 ;i <alarmResponses.length;i++){
      if(alarmResponses[i].id.toUnsigned(32) == id.toUnsigned(32)){
        alarmResponses[i].responseAt = DateTime.now();
        alarmResponses[i].responseTime = alarmResponses[i].responseAt!.difference(alarmResponses[i].alarmAt);
      }
    }
    await pref.setString(alarmResponseDataKey, json.encode(alarmResponses));
  }
  Future<List<Alarm>> getRespondedAlarm()async {
    var pref = await SharedPreferences.getInstance();
    await pref.reload();
    String alarmString = pref.getString(alarmResponseDataKey)??'null';
    List<Alarm> alarmResponses = [];
    if(alarmString != ''){
      var jsonData = jsonDecode(alarmString);
      alarmResponses = List<Alarm>.from(jsonData.map((e){
        return Alarm.fromJson(e);
      }));
    }

    return alarmResponses;
  }


}