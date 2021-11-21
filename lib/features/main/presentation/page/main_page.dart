import 'package:flutter/material.dart';
import 'package:personal_alarm/features/list_alarm/presentation/page/list_alarm_page.dart';
import 'package:personal_alarm/features/main/presentation/widgets/clock_widget.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:personal_alarm/features/stats/presentation/page/stats_page.dart';

class MainPage extends StatefulWidget {
  static const tag = "/main-page";
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FocusOn _currentFocus = FocusOn.none;
  double maxWH = 0;
  double currentHours = DateTime.now().hour.toDouble();
  double currentMinutes = DateTime.now().minute.toDouble();
  bool isAM = true;

  @override
  Widget build(BuildContext context) {
    maxWH = (MediaQuery.of(context).size.width > 400)
        ? 400
        : MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                          _calculateAngle(details);
                        },
                        onVerticalDragUpdate: (DragUpdateDetails details) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _twoDigitStringFormat(currentHours),
                      style: TextStyle(
                          fontSize: (_currentFocus == FocusOn.hours) ? 50 : 30),
                    ),
                    const Text(":", style: TextStyle(fontSize: 30)),
                    Text(_twoDigitStringFormat(currentMinutes),
                        style: TextStyle(
                            fontSize:
                                (_currentFocus == FocusOn.minutes) ? 50 : 30)),
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
                        padding: const EdgeInsets.all(20.0).copyWith(left: 0),
                        child: Text(
                          (isAM) ? "AM" : "PM",
                          style: const TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                    ),
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
                    onTap: (){
                      Navigator.pushNamed(context, ListAlarmPage.tag);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.menu),
                        Text("List Alarm")
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.black.withAlpha(100), width: 2)),
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
                    onTap:(){
                      Navigator.pushNamed(context, StatsPage.tag);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.equalizer),
                        Text("Stats")
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  String _twoDigitStringFormat(double val) {
    int intVal = val.toInt();
    if (intVal < 10) {
      return "0$intVal";
    } else {
      return "$intVal";
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
