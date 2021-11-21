import 'package:flutter/cupertino.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/service/shared_pref_service.dart';
import 'package:provider/provider.dart';

class AlarmProvider extends ChangeNotifier{
  final SharedPrefService _sharedPrefService = SharedPrefService();
  List<Alarm> _alarms = [];
  init() async {
    _alarms = await _sharedPrefService.getAlarm();
    notifyListeners();
  }
  List<Alarm> get alarms => _alarms;
  addAlarms(Alarm alarm) async {
    _alarms.add(alarm);
    await _sharedPrefService.saveAlarm(_alarms);
    notifyListeners();
  }
}