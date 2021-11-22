import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/service/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmService {
  static SendPort? uiSendPort;
  static const String isolateName = 'isolate';

  /// A port used to communicate from a background isolate to the UI isolate.
  final ReceivePort port = ReceivePort();

  void init() {
    AndroidAlarmManager.initialize();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
    port.listen((_) async {
      var p = SharedPreferences.getInstance();
      var p2 = await p;
      await p2.reload();
      print("TRIGGER!!!");
    });
  }

  void registerAlarm(Alarm _alarm) {
    print("alarm created at ${TimeHelper.getTimeDiffFromTime(_alarm.alarmAt).inHours} : ${TimeHelper.getTimeDiffFromTime(_alarm.alarmAt).inMinutes}");
    AndroidAlarmManager.oneShot(TimeHelper.getTimeDiffFromTime(_alarm.alarmAt),
        _alarm.id.toUnsigned(32), callback, exact: true, wakeup: true, allowWhileIdle: true, alarmClock: true);
  }

  static Future<void> callback() async {
    // print("ID IS HERE! $idAlarm");
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: true,
      // Android only - API >= 28
      volume: 1,
      // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
    Future.delayed(const Duration(seconds: 2),(){
      FlutterRingtonePlayer.stop();
    });
    await SharedPrefService().deleteLatestAlarm();
    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
}
