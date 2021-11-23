import 'package:flutter/material.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:personal_alarm/core/provider/stats_provider.dart';
import 'package:personal_alarm/features/list_alarm/presentation/page/list_alarm_page.dart';
import 'package:personal_alarm/features/stats/presentation/page/stats_page.dart';
import 'package:provider/provider.dart';

import 'features/main/presentation/page/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey(debugLabel: "Main Navigator");
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlarmProvider>(create: (_) => AlarmProvider()),
        ChangeNotifierProvider<StatsProvider>(create: (_) => StatsProvider())
      ],
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(),
        initialRoute: MainPage.tag,
        routes: {
          MainPage.tag: (_) => const MainPage(),
          ListAlarmPage.tag: (_) => const ListAlarmPage(),
          StatsPage.tag: (_) => const StatsPage()
        },
      ),
    );
  }
}
