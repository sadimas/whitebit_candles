class CandleData {
 final int? timestampMillis;
 final double? open;
 final double? high;
 final double? low;
 final double? close;
 final double? vol;
 final double? amount;
  CandleData({
    required this.timestampMillis,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.vol,
    required this.amount,
  });

  
}

class TradePair {
  final Currency base;
  final Currency counter;

  TradePair(this.base, this.counter);
}

class Currency {
  final String name;

  Currency(this.name);
}

enum ESpotFutureMode {
  spot,
  futures;

  bool get isSpot => this == spot;

  bool get isFutures => this == futures;
}

enum DataInterval {
  oneMin,
  fiveMin,
  fifteenMin,
  thirtyMin,
  oneHour,
  fourHours,
  oneDay;

  static DataInterval get defaultValue => fifteenMin;
}
