class CandleModel {
  double time;
  double open;
  double high;
  double low;
  double close;
  double volumeFrom;
  double volumeTo;

  CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volumeFrom,
    required this.volumeTo,
  });

  factory CandleModel.fromJson(dynamic json) {
    return CandleModel(
      time: json['time'].toDouble(),
      open: json['open'].toDouble(),
      high: json['high'].toDouble(),
      low: json['low'].toDouble(),
      close: json['close'].toDouble(),
      volumeFrom: json['volumefrom'].toDouble(),
      volumeTo: json['volumeto'].toDouble(),
    );
  }
}
