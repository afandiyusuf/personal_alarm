import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<AlarmProvider>().alarms.length,
              itemBuilder: (context, index) {
                return AlarmTile(alarmAt: context.watch<AlarmProvider>().alarms[index].alarmAt,onDelete: (){
                  _onDelete(context, index);
                },);
              },
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: Colors.black.withAlpha(100), width: 2)),
                width: 60,
                height: 60,
                child: const Center(
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 40),
                    )),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  _onDelete(BuildContext context, int index) async {
    var provider = Provider.of<AlarmProvider>(context,listen:false);
    await provider.deleteAlarmAt(index);
    Fluttertoast.showToast(msg: "Alarm berhasil dihapus");
  }
}
