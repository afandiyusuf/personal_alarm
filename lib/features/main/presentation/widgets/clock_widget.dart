import 'package:flutter/material.dart';
import 'dart:math' as math;
enum FocusOn{
  hours,
  minutes,
  none
}
class ClockWidget extends StatelessWidget {
  final int hours;
  final int min;
  final FocusOn focusOn;
  const ClockWidget({Key? key, required this.hours, required this.min, required this.focusOn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWH = (MediaQuery.of(context).size.width > 400)
        ? 400
        : MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FittedBox(
        child: SizedBox(
            width: maxWH,
            height: maxWH,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                    right: 0,
                    child: Container(
                  width: maxWH,
                  height: maxWH,
                  child: Image.asset("assets/center_dot.png",fit: BoxFit.contain,),
                )),
                Positioned(
                    left: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle:(360/12)*hours* math.pi/180,
                      child: Opacity(
                        opacity: (focusOn == FocusOn.none || focusOn == FocusOn.hours)?1:0.2,
                        child: Container(
                          width: maxWH,
                          height: maxWH,
                          child: Image.asset("assets/hours.png",fit: BoxFit.contain),
                        ),
                      ),
                    )),
                Positioned(
                    left: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: (360/60)*min* math.pi/180,
                      child: Opacity(
                        opacity: (focusOn == FocusOn.none || focusOn == FocusOn.minutes)?1:0.2,
                        child: Container(
                          width: maxWH,
                          height: maxWH,
                          child: Image.asset("assets/minutes.png",fit: BoxFit.contain),
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
