import 'package:personal_alarm/core/helper/string_helper.dart';

class TimeHelper {
  static String getFormattedTimeDiffFromNowHoursAndMin(
      double currentHours, double currentMinutes, bool isAM) {
    DateTime _n = DateTime.now();
    double realHour = (isAM) ? currentHours : currentHours + 12;
    DateTime alarm = DateTime.parse(
        "${_n.year}-${_n.month}-${_n.day} ${StringHelper.twoDigitStringFormatDouble(realHour)}:${StringHelper.twoDigitStringFormatDouble(currentMinutes)}");
    if (_n.hour > alarm.hour) {
      alarm = alarm.add(const Duration(hours: 24));
    }

    Duration diff = alarm.difference(_n);

    return "Alarm in ${diff.inHours} hours, ${diff.inMinutes % 60} minutes";
  }

  static String getFormattedTimeDiffFromNow(DateTime alarm){
    DateTime _n = DateTime.now();
     if (_n.hour > alarm.hour) {
      alarm = alarm.add(const Duration(hours: 24));
    }
    Duration diff = alarm.difference(_n);
    return "Alarm in ${diff.inHours} hours, ${diff.inMinutes % 60} minutes";
  }
  static Duration getTimeDiffFromTime(DateTime alarm){
    DateTime _n = DateTime.now();
    if (_n.hour > alarm.hour) {
      alarm = alarm.add(const Duration(hours: 24));
    }
    Duration diff = alarm.difference(_n);
    return diff;
  }
}
