import 'package:flutter/material.dart';

class ListAlarmPage extends StatelessWidget {
  static const tag = "/list-alarm";
  const ListAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Alarm"),),
    );
  }
}
