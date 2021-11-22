import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personal_alarm/core/model/alarm.dart';
import 'package:personal_alarm/core/provider/alarm_provider.dart';
import 'package:personal_alarm/features/list_alarm/presentation/widgets/alarm_tile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListAlarmPage extends StatefulWidget {
  static const tag = "/list-alarm";

  const ListAlarmPage({Key? key}) : super(key: key);

  @override
  State<ListAlarmPage> createState() => _ListAlarmPageState();
}

class _ListAlarmPageState extends State<ListAlarmPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      var provider = Provider.of<AlarmProvider>(context, listen: false);
      provider.refreshAlarm();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Alarm"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<AlarmProvider>().alarms.length,
              itemBuilder: (context, index) {
                return AlarmTile(
                  alarmAt: context.watch<AlarmProvider>().alarms[index].alarmAt,
                  onDelete: () {
                    _onDelete(context, index);
                  },
                );
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
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  _onDelete(BuildContext context, int index) async {
    var provider = Provider.of<AlarmProvider>(context, listen: false);
    Alarm _alarm = provider.alarms[index];
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text("Apakah kamu yakin ingin menghapus alarm ini? "
                "\n\n${DateFormat("hh:mm a").format(_alarm.alarmAt)}"),
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
    if (result == true) {
      await provider.deleteAlarmAt(index);
      Fluttertoast.showToast(msg: "Alarm berhasil dihapus");
    }
  }
}
