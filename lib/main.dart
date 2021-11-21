import 'package:flutter/material.dart';
import 'package:personal_alarm/features/list_alarm/presentation/page/list_alarm_page.dart';
import 'package:personal_alarm/features/stats/presentation/page/stats_page.dart';

import 'features/main/presentation/page/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      initialRoute: MainPage.tag,
      routes: {
        MainPage.tag: (_) => MainPage(),
        ListAlarmPage.tag: (_) => ListAlarmPage(),
        StatsPage.tag: (_) => StatsPage()
      },
    );
  }
}
