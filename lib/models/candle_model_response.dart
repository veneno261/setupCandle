class CandleModelResponse {
  final bool isSetupCandle;
  final String candleColor;
  final String candleDirection;
  final String tokenName;
  final String timeFrame;
  final String dhm;
  final double open;
  final double close;
  final double high;
  final double low;
  final double volume;
  final Map<String, dynamic>? response;

  CandleModelResponse({
    required this.isSetupCandle,
    required this.candleColor,
    required this.candleDirection,
    required this.tokenName,
    required this.timeFrame,
    required this.dhm,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.volume,
    this.response,
  });

  // Copy with method to create a new instance with some modified values
  CandleModelResponse copyWith({
    bool? isSetupCandle,
    String? candleColor,
    String? candleDirection,
    String? tokenName,
    String? timeFrame,
    String? dhm,
    double? open,
    double? close,
    double? high,
    double? low,
    double? volume,
    Map<String, dynamic>? response,
  }) {
    return CandleModelResponse(
      isSetupCandle: isSetupCandle ?? this.isSetupCandle,
      candleColor: candleColor ?? this.candleColor,
      candleDirection: candleDirection ?? this.candleDirection,
      tokenName: tokenName ?? this.tokenName,
      timeFrame: timeFrame ?? this.timeFrame,
      dhm: dhm ?? this.dhm,
      open: open ?? this.open,
      close: close ?? this.close,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      response: response ?? this.response,
    );
  }

  CandleModelResponse.initialize()
      : isSetupCandle = false,
        candleColor = '',
        candleDirection = '',
        timeFrame = '',
        tokenName = '',
        dhm = '',
        open = 0.0,
        close = 0.0,
        high = 0.0,
        low = 0.0,
        volume = 0.0,
        response = null;

  Map<String, dynamic> toJson() {
    return {
      'isSetupCandle': isSetupCandle,
      'candleColor': candleColor,
      'candleDirection': candleDirection,
      'tokenName': tokenName,
      'timeFrame': timeFrame,
      'dhm': dhm,
      'open': open,
      'close': close,
      'high': high,
      'low': low,
      'volume': volume,
    };
  }
}
