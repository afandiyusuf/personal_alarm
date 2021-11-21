import 'package:flutter/material.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListAlarmPage extends StatelessWidget {
  static const tag = "/list-alarm";

  const ListAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Alarm"),
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, _p, _c) {
          return ListView.builder(
            itemCount: _p.alarms.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text(
                    DateFormat("hh:mm a").format(_p.alarms[index].alarmAt)),
              );
            },
          );
        },
      ),
    );
  }
}
