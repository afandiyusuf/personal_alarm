import 'package:flutter/material.dart';
import 'package:personal_alarm/features/main/presentation/widgets/clock_widget.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
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
                        child: Container(
                          width: maxWH,
                          height: maxWH,
                          child: ClockWidget(
                              hours: currentHours.toInt(),
                              min: currentMinutes.toInt(),
                              focusOn: _currentFocus),
                        )))),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _2digitStringFormat(currentHours),
                      style: TextStyle(
                          fontSize: (_currentFocus == FocusOn.hours) ? 50 : 30),
                    ),
                    Text(":", style: TextStyle(fontSize: 30)),
                    Text(_2digitStringFormat(currentMinutes),
                        style: TextStyle(
                            fontSize:
                                (_currentFocus == FocusOn.minutes) ? 50 : 30)),
                    SizedBox(
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
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black.withAlpha(100), width: 2)),
                  width: 80,
                  height: 80,
                  child: Center(
                      child: Text(
                    "+",
                    style: TextStyle(fontSize: 40),
                  )),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  String _2digitStringFormat(double val) {
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
