import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmTile extends StatefulWidget {
  final DateTime alarmAt;
  final Function onDelete;
  const AlarmTile({Key? key, required this.alarmAt, required this.onDelete}) : super(key: key);

  @override
  _AlarmTileState createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat("hh:mm").format(widget.alarmAt),
                  style: TextStyle(fontSize: 40),
                )
              ],
            ),
          ),
          InkWell(
            onTap: (){
              widget.onDelete();
            },
            child: Row(
              children: [
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
