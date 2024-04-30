import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whitebit_app/models/candle_model.dart';

import '../repositories/abstract_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  List<CandleData>? _candleList;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title), centerTitle: true),
      body: StreamBuilder(
          stream: GetIt.I<CandleProvider>().getCandleData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _candleList = snapshot.data;
              if (_candleList != null) {
                data = _candleList!
                    .map(
                      (e) => _ChartData(
                        x: DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch((e.timestampMillis! * 1000))),
                        close: e.close!,
                        high: e.high!,
                        low: e.low!,
                        open: e.open!,
                      ),
                    )
                    .toList();
              }
            }
            return SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(minimum: 57000, maximum: 63000, interval: 500),
                tooltipBehavior: _tooltip,
                series: <CartesianSeries<_ChartData, String>>[
                  CandleSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    highValueMapper: (_ChartData data, _) => data.high,
                    lowValueMapper: (_ChartData data, _) => data.low,
                    openValueMapper: (_ChartData data, _) => data.open,
                    closeValueMapper: (_ChartData data, _) => data.close,
                    name: 'BTC/USDT',
                  )
                ]);
          }),
    );
  }
}

class _ChartData {
  _ChartData({required this.x, required this.high, required this.low, required this.open, required this.close});

  final String x;
  final double high;
  final double low;
  final double open;
  final double close;
}
