import 'dart:async';

import 'package:dio/dio.dart';
import 'package:whitebit_app/constants/constants.dart';

import 'package:whitebit_app/models/candle_model.dart';

import 'abstract_repository.dart';

class CandleRepository implements CandleProvider {
  final Dio dio;
  CandleRepository({
    required this.dio,
  });

  @override
  Stream<List<CandleData>> getCandleData() async* {
    try {
      var streamController = StreamController<List<CandleData>>();
      final response = await dio.get(AppConst.apiWhitebit);
      final data = response.data as Map<String, dynamic>;
      final dataResult = data['result'] as List<dynamic>;
      List<CandleData> listCandles = [];

      listCandles = dataResult.map((e) {
        return CandleData(
          amount: double.tryParse(e[6]),
          close: double.tryParse(e[2]),
          high: double.tryParse(e[3]),
          low: double.tryParse(e[4]),
          open: double.tryParse(e[1]),
          vol: double.tryParse(e[5]),
          timestampMillis: e[0],
        );
      }).toList();

      streamController.add(listCandles);

      yield* streamController.stream;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void subscribe({required TradePair tradePair, required DataInterval interval, ESpotFutureMode mode = ESpotFutureMode.spot, int limit = 100}) {
    // TODO: implement subscribe
  }

  @override
  // TODO: implement ticker
  Stream<CandleData> get ticker => throw UnimplementedError();
}
