import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/service/shared_pref_service.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsProvider extends ChangeNotifier{
  SharedPrefService _sharedPrefService = SharedPrefService();
  List<Alarm> _alarms = [];
  List<AlarmChartData> _chartData = [];
  List<charts.Series<AlarmChartData,String>> _alarmChartDataSeries = [];
  List<charts.Series<AlarmChartData,String>> get alarmChartDataSeries => _alarmChartDataSeries;
  Future<void >init() async {
    _alarms = await _sharedPrefService.getRespondedAlarm();
    print("Alarms is $_alarms");
    _chartData = List<AlarmChartData>.from(_alarms.map((e) {
      if(e.responseAt != null){
        return AlarmChartData(
            DateFormat("hh:mm a").format(e.alarmAt), e.responseTime!.inSeconds);
      }else{
        return AlarmChartData(DateFormat("mm").format(e.alarmAt), Duration(seconds: 1000).inSeconds);
      }

    }));

    print("Chart data is $_chartData");
    _alarmChartDataSeries = [
      charts.Series<AlarmChartData,String>(
      id: "Alarm Response Time",
    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AlarmChartData alarm, _) => alarm.dateTime,
        measureFn: (AlarmChartData alarm, _) => alarm.responseTime,
        data:_chartData
      )
    ];
    notifyListeners();
  }
}

class AlarmChartData{
  final String dateTime;
  final int responseTime;
  AlarmChartData(this.dateTime, this.responseTime);
}
