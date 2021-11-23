import 'package:flutter/material.dart';
import 'package:personal_alarm/core/provider/stats_provider.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  static const String tag = "/stats";

  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      print("INIT");
      Provider.of<StatsProvider>(context, listen: false).init();
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Response Speed (in seconds)",
          style: TextStyle(fontSize: 12),
        ),
        backgroundColor: Colors.black,
      ),
      body: (loading)
          ? Center(child: Text("Loading Graph..."))
          : charts.BarChart(
              context.watch<StatsProvider>().alarmChartDataSeries,
              vertical: true,
            ),
    );
  }
}
