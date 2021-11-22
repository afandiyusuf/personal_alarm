import 'package:flutter/material.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:personal_alarm/features/list_alarm/presentation/widgets/alarm_tile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListAlarmPage extends StatelessWidget {
  static const tag = "/list-alarm";

  const ListAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Alarm"),backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: context.watch<AlarmProvider>().alarms.length,
        itemBuilder: (context, index) {
          return AlarmTile(alarmAt: context.watch<AlarmProvider>().alarms[index].alarmAt,onDelete: (){
            _onDelete(context, index);
          },);
        },
      ),
    );
  }

  _onDelete(BuildContext context, int index) async {
    var provider = Provider.of<AlarmProvider>(context,listen:false);
    await provider.deleteAlarmAt(index);
  }
}
