import '../models/candle_model.dart';

abstract class CandleProvider {

  void subscribe({
    required TradePair tradePair,
    required DataInterval interval,
    ESpotFutureMode mode = ESpotFutureMode.spot,
    int limit = 100,
  });

  Stream<CandleData> get ticker;

  Stream<List<CandleData>> getCandleData();

 
  void dispose();
}