import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_alarm/core/helper/time_helper.dart';

class AlarmTile extends StatefulWidget {
  final DateTime alarmAt;
  final Function onDelete;

  const AlarmTile({Key? key, required this.alarmAt, required this.onDelete})
      : super(key: key);

  @override
  _AlarmTileState createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0).copyWith(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat("hh:mm a").format(widget.alarmAt),
                  style: const TextStyle(fontSize: 40),
                ),
                Text(TimeHelper.getFormattedTimeDiffFromNow(widget.alarmAt))
              ],
            ),
          ),
          InkWell(
            onTap: () {
              widget.onDelete();
            },
            child: Row(
              children: const [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
