import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmNotificationService{
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  void init() async {
    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(int _, String? __, String?___, String? ____){

  }
  void selectNotification(String? payload) async {

  }

  Future<void> createAlarm(Alarm alarm)async {
    log("Alarm notification created");
    Duration atTime = TimeHelper.getTimeDiffFromTime(alarm.alarmAt);
    await flutterLocalNotificationsPlugin?.zonedSchedule(
        alarm.id,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(atTime),

        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description', importance: Importance.max,enableVibration: true)),
        androidAllowWhileIdle: true,
        payload: alarm.id.toString(),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

    await flutterLocalNotificationsPlugin?.show(
        alarm.id,
        'scheduled title',
        'scheduled body',
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description', importance: Importance.max,enableVibration: true)),
        payload: alarm.id.toString());

  }
}