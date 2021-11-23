import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/service/alarm_notification_service.dart';
import 'package:personal_alarm/core/service/alarm_service.dart';
import 'package:personal_alarm/core/service/shared_pref_service.dart';


class AlarmProvider extends ChangeNotifier{
  final SharedPrefService _sharedPrefService = SharedPrefService();
  final AlarmService _alarmService = AlarmService();
  final AlarmNotificationService _alarmNotificationService = AlarmNotificationService();
  List<Alarm> _alarms = [];

  bool _isAlarmActive = false;
  bool get isAlarmActive => _isAlarmActive;
  init() async {
    _alarms = await _sharedPrefService.getAlarm();
    _alarmService.init((){
      _onAlarmTriggered();
    });
    _alarmNotificationService.init();
    notifyListeners();
  }
  _onAlarmTriggered() async {
    log("Alarm is triggering!!!");
    _isAlarmActive = true;
    notifyListeners();
  }
  responseAlarm() async {
    _isAlarmActive = false;
    int? tempLatestAlarmId = await _sharedPrefService.getTempLatestAlarmId();
    if(tempLatestAlarmId != null){
      await _sharedPrefService.setResponseTimeAlarm(tempLatestAlarmId);
      //delete latest alarm id
      await _sharedPrefService.saveLatestTempAlarmId(null);
      await _sharedPrefService.updateLatestAlarm();
    }else{
      log("TEMP LATEST ALARM ID IS NULL");
    }
    notifyListeners();
  }

  refreshAlarm() async{
    _alarms = await _sharedPrefService.getAlarm();
    notifyListeners();
  }
  List<Alarm> get alarms => _alarms;
  set alarms(List<Alarm> val){
    _alarms = val;
    notifyListeners();
  }
  addAlarms(Alarm alarm) async {
    _alarms.add(alarm);
    await _sharedPrefService.saveAlarm(_alarms);
    _alarmService.registerAlarm(alarm);
    await _alarmNotificationService.createAlarm(alarm);
    // await _alarmNotificationService.createAlarm(alarm);
    log("alarm successfully created");
    notifyListeners();
  }

  deleteAlarmAt(int index) async{
    _alarms.removeAt(index);
    await _sharedPrefService.saveAlarm(_alarms);
    alarms =  await _sharedPrefService.getAlarm();
    notifyListeners();
  }
}