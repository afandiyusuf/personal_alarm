import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  static const String tag = "/stats";

  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stats")),
    );
  }
}
