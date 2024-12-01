import 'package:candle_setup_finder/models/candle_model.dart';
import 'package:candle_setup_finder/models/candle_model_response.dart';

List<String?> isIndecisionCandle(CandleModel candle) {
  double body = (candle.close - candle.open).abs().toDouble();
  double topShadow = candle.high - (candle.close > candle.open ? candle.close : candle.open).toDouble();
  double bottomShadow = ((candle.close > candle.open ? candle.open : candle.close) - candle.low).toDouble();
  String bodyColor = (candle.close - candle.open).isNegative ? 'red' : 'green';

  // Check for bullish indecision candle (long bottom shadow, small top shadow)
  if ((bottomShadow >= 2 * body) && (topShadow <= 1.5 * body)) {
    return ["Bullish", bodyColor];
  }

  // Check for bearish indecision candle (long top shadow, small bottom shadow)
  if ((topShadow >= 2 * body) && (bottomShadow <= 1.5 * body)) {
    return ["Bearish", bodyColor];
  }

  return [null, null]; // No indecision candle
}

CandleModelResponse findSetupCandle({
  required Map<String, dynamic> candles,
  required int lookBack,
  required String tokenName,
  required String timFrame,
  required String dhm,
}) {
  if (candles['Data']['Data'] == null) {
    return CandleModelResponse(
      isSetupCandle: false,
      candleColor: '',
      candleDirection: '',
      tokenName: tokenName,
      timeFrame: timFrame,
      dhm: dhm,
      open: 0.0,
      close: 0.0,
      high: 0.0,
      low: 0.0,
      response: candles,
      volume: 0.0,
    );
  }

  //print(candles['Data']['Data']);
  CandleModel candle = CandleModel.fromJson(candles['Data']['Data'][candles['Data']['Data'].length - lookBack]);

  List<String?> result = isIndecisionCandle(candle);

  if (result.first != null && result.first != '') {
    return CandleModelResponse(
      isSetupCandle: true,
      candleColor: result.last!,
      candleDirection: result.first!,
      tokenName: tokenName,
      timeFrame: timFrame,
      dhm: dhm,
      open: candle.open,
      close: candle.close,
      high: candle.high,
      low: candle.low,
      volume: candle.volumeFrom,
      response: candles,
    );
  } else {
    return CandleModelResponse(
      isSetupCandle: false,
      candleColor: '',
      candleDirection: '',
      tokenName: tokenName,
      timeFrame: timFrame,
      dhm: dhm,
      open: 0.0,
      close: 0.0,
      high: 0.0,
      low: 0.0,
      volume: 0.0,
      response: candles,
    );
  }
}
