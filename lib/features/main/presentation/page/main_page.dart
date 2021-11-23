import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:personal_alarm/core/helper/string_helper.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:personal_alarm/features/list_alarm/presentation/page/list_alarm_page.dart';
import 'package:personal_alarm/features/main/presentation/widgets/clock_widget.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:personal_alarm/features/stats/presentation/page/stats_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const tag = "/main-page";

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  FocusOn _currentFocus = FocusOn.none;
  double maxWH = 0;
  double currentHours = DateTime.now().hour.toDouble();
  double currentMinutes = DateTime.now().minute.toDouble();
  bool isAM = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    Provider.of<AlarmProvider>(context, listen: false).init();
  }
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<AlarmProvider>(context,listen: false).refreshAlarm();
    }
  }

  @override
  Widget build(BuildContext context) {
    maxWH = (MediaQuery.of(context).size.width > 400)
        ? 400
        : MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Create Alarm",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              if (_currentFocus == FocusOn.hours) {
                                _currentFocus = FocusOn.minutes;
                              } else {
                                _currentFocus = FocusOn.hours;
                              }
                              setState(() {
                                _currentFocus = _currentFocus;
                              });
                            },
                            onHorizontalDragUpdate: (DragUpdateDetails details) {
                              if(_currentFocus == FocusOn.none){
                                _currentFocus = FocusOn.minutes;
                              }
                              _calculateAngle(details);
                            },
                            onVerticalDragUpdate: (DragUpdateDetails details) {
                              if(_currentFocus == FocusOn.none){
                                _currentFocus = FocusOn.minutes;
                              }
                              _calculateAngle(details);
                            },
                            child: SizedBox(
                              width: maxWH,
                              height: maxWH,
                              child: ClockWidget(
                                  hours: currentHours.toInt(),
                                  min: currentMinutes.toInt(),
                                  focusOn: _currentFocus),
                            )))),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringHelper.twoDigitStringFormatDouble(currentHours),
                              style: TextStyle(
                                  fontSize:
                                      (_currentFocus == FocusOn.hours) ? 50 : 30),
                            ),
                            const Text(":", style: TextStyle(fontSize: 30)),
                            Text(
                                StringHelper.twoDigitStringFormatDouble(
                                    currentMinutes),
                                style: TextStyle(
                                    fontSize: (_currentFocus == FocusOn.minutes)
                                        ? 50
                                        : 30)),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAM = !isAM;
                                  _currentFocus = FocusOn.none;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(20.0).copyWith(left: 0),
                                child: Text(
                                  (isAM) ? "AM" : "PM",
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(TimeHelper.getFormattedTimeDiffFromNowHoursAndMin(
                            currentHours, currentMinutes, isAM)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ListAlarmPage.tag);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [Icon(Icons.menu), Text("List Alarm")],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          _showCreateAlarmConfirmation();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: Colors.black.withAlpha(100), width: 2)),
                            width: 80,
                            height: 80,
                            child: const Center(
                                child: Text(
                              "+",
                              style: TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, StatsPage.tag);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [Icon(Icons.equalizer), Text("Stats")],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
            Visibility(
                visible: context.watch<AlarmProvider>().isAlarmActive,
                child: Column(children: [
              Expanded(
                child: Container(
                  color: Colors.black.withAlpha(100),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        Provider.of<AlarmProvider>(context,listen:false).responseAlarm();
                        Navigator.pushNamed(context, StatsPage.tag);
                      },
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Alarm is ringing!",style: TextStyle(fontSize: 20),),
                              SizedBox(height: 20,),
                              Text("Tap to response this alarm")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],))
          ],
        ),
      ),
    );
  }

  _showCreateAlarmConfirmation() async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text("Are you sure to create alarm at "
                "\n${StringHelper.twoDigitStringFormatDouble(currentHours)}"
                ":${StringHelper.twoDigitStringFormatDouble(currentMinutes)} ${(isAM) ? "AM" : "PM"}\n\n${TimeHelper.getFormattedTimeDiffFromNowHoursAndMin(currentHours, currentMinutes, isAM)}"),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: const SizedBox(
                    width: 80,
                    height: 30,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    )),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child:
                      const SizedBox(width: 80, height: 30, child: Text("OK")))
            ],
          );
        });

    if (result) {
      DateTime _n = DateTime.now();
      AlarmProvider alarmProvider =
          Provider.of<AlarmProvider>(context, listen: false);
      double realHour = (isAM) ? currentHours : currentHours + 12;
      alarmProvider.addAlarms(Alarm(
          DateTime.now().millisecondsSinceEpoch.toUnsigned(32),
          DateTime.parse("${StringHelper.twoDigitStringFormatInt(_n.year)}"
              "-${StringHelper.twoDigitStringFormatInt(_n.month)}"
              "-${StringHelper.twoDigitStringFormatInt(_n.day)}"
              " ${StringHelper.twoDigitStringFormatDouble(realHour)}"
              ":${StringHelper.twoDigitStringFormatDouble(currentMinutes)}"),
          true,
          false));
      Fluttertoast.showToast(msg: "Alarm berhasil dibuat!");
    }
  }

  _calculateAngle(DragUpdateDetails details) {
    var centerX = maxWH / 2;
    var centerY = maxWH / 2;
    var deltaX = details.localPosition.dx - centerX;
    var deltaY = centerY - details.localPosition.dy;
    var rad = math.atan2(deltaX, deltaY);
    var deg = rad * (180 / math.pi);
    if (_currentFocus == FocusOn.hours) {
      _degToHours(deg);
    } else if (_currentFocus == FocusOn.minutes) {
      _degToMin(deg);
    }
    setState(() {});
  }

  _degToMin(double deg) {
    if (deg > 0) {
      currentMinutes = ((deg / 180) * 30);
    } else {
      double absDeg = deg.abs();
      currentMinutes = (((180 - absDeg) / 180 * 30) + 30);
    }
  }

  _degToHours(double deg) {
    if (deg > 0) {
      currentHours = (deg / 180) * 6;
    } else {
      double absDeg = deg.abs();
      currentHours = ((180 - absDeg) / 180 * 6) + 6;
    }
  }
}
