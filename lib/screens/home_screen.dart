import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whitebit_app/constants/constants.dart';
import 'package:whitebit_app/models/candle_model.dart';

import '../repositories/abstract_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CandleData>? _candleList;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late double min;
  late double max;
  @override
  void initState() {
    data = [];
    min = 0;
    max = 100000;
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _streamCandleData(),
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
                final List<double> minList = data.map((e) => e.low).toList();
                final List<double> maxList = data.map((e) => e.high).toList();
                minList.sort();
                maxList.sort();
                min = minList.first;
                max = maxList.last;
                min = (min ~/ 100) * 100 - 500;
                max = (max ~/ 100) * 100 + 500;
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                    plotAreaBackgroundColor: Colors.black.withOpacity(.2),
                    borderColor: Colors.black,
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: NumericAxis(minimum: min, maximum: max, interval: 500),
                    tooltipBehavior: _tooltip,
                    series: <CartesianSeries<_ChartData, String>>[
                      CandleSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        highValueMapper: (_ChartData data, _) => data.high,
                        lowValueMapper: (_ChartData data, _) => data.low,
                        openValueMapper: (_ChartData data, _) => data.open,
                        closeValueMapper: (_ChartData data, _) => data.close,
                        name: AppConst.candlesPair,
                      )
                    ]),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Stream<List<CandleData>> _streamCandleData() => GetIt.I<CandleProvider>().getCandleData();
}

class _ChartData {
  _ChartData({required this.x, required this.high, required this.low, required this.open, required this.close});

  final String x;
  final double high;
  final double low;
  final double open;
  final double close;
}
