import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  void selectNotification(String? payload) async {}

  Future<void> createAlarm(Alarm alarm) async {
    Duration atTime = TimeHelper.getTimeDiffFromTime(alarm.alarmAt);
    await flutterLocalNotificationsPlugin?.zonedSchedule(
        alarm.id,
        'Alarm  ${DateFormat('hh:mm a').format(alarm.alarmAt)}',
        "Tap to check your response time",
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
        payload: alarm.id.toString());
  }
}
