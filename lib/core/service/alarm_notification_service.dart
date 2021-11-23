import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:personal_alarm/core/service/shared_pref_service.dart';
import 'package:personal_alarm/features/stats/presentation/page/stats_page.dart';
import 'package:personal_alarm/main.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:personal_alarm/main.dart';

class AlarmNotificationService {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  void init() async {
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int _, String? __, String? ___, String? ____) {}

  void selectNotification(String? payload) async {
    //alarm created notification have null payload, otherwise is notification from alarm active
    if (payload != null) {
      int id = int.parse(payload).toUnsigned(32);
      await SharedPrefService().setResponseTimeAlarm(id);
      //delete latest alarm id
      await SharedPrefService().saveLatestTempAlarmId(null);
      await SharedPrefService().updateLatestAlarm();
      try{
        Navigator.pushNamed(MyApp.navigatorKey.currentState!.context, StatsPage.tag);
      }catch(e){}
    } else {
      log("TEMP LATEST ALARM ID IS NULL");
    }
  }

  Future<void> createAlarm(Alarm alarm) async {
    Duration atTime = TimeHelper.getTimeDiffFromTime(alarm.alarmAt);
    await flutterLocalNotificationsPlugin?.zonedSchedule(
        alarm.id,
        'Alarm  ${DateFormat('hh:mm a').format(alarm.alarmAt)}',
        "Tap to record your response time",
        tz.TZDateTime.now(tz.local).add(atTime),
        NotificationDetails(
            android: AndroidNotificationDetails('Alarm',
                'Alarm  ${DateFormat('hh:mm a').format(alarm.alarmAt)}',
                channelDescription: "Tap to check your response time",
                importance: Importance.max,
                enableVibration: true)),
        androidAllowWhileIdle: true,
        payload: alarm.id.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    await flutterLocalNotificationsPlugin?.show(
      alarm.id,
      'Alarm  ${DateFormat('hh:mm a').format(alarm.alarmAt)} created',
      TimeHelper.getFormattedTimeDiffFromNow(alarm.alarmAt),
      NotificationDetails(
          android: AndroidNotificationDetails("Alarm",
              'Alarm  ${DateFormat('hh:mm a').format(alarm.alarmAt)} created',
              channelDescription:
                  TimeHelper.getFormattedTimeDiffFromNow(alarm.alarmAt),
              importance: Importance.max,
              enableVibration: true)),
    );
  }
}
