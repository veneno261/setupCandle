import '../models/candle_model_response.dart';

class SetupCandleConditions {
  final CandleModelResponse response;
  final List<List<double>> smas;
  final int lookBack;

  SetupCandleConditions({
    required this.response,
    required this.smas,
    required this.lookBack,
  });

  // sma[0] is sma7
  // sma[1] is sma25
  // sma[2] is sma99

  bool isBullish() => response.candleDirection == 'Bullish';
  bool isBearish() => response.candleDirection == 'Bearish';

  // conditions for bullish candle
  bool isPriceAboveSma7() => response.high > smas[0][smas[0].length - lookBack];
  bool isSma7AboveSma25() => smas[0][smas[0].length - lookBack] > smas[1][smas[1].length - lookBack];
  bool isSma25AboveSma99() => smas[1][smas[1].length - lookBack] > smas[2][smas[2].length - lookBack];

  // conditions for bearish candle
  bool isPriceBelowSma7() => response.low < smas[0][smas[0].length - lookBack];
  bool isSma7BelowSma25() => smas[0][smas[0].length - lookBack] < smas[1][smas[1].length - lookBack];
  bool isSma25BelowSma99() => smas[1][smas[1].length - lookBack] < smas[2][smas[2].length - lookBack];

  bool allBullishConditionsMet() {
    return isBullish() && isPriceAboveSma7() && isSma7AboveSma25() && isSma25AboveSma99();
  }

  bool allBearishConditionsMet() {
    return isBearish() && isPriceBelowSma7() && isSma7BelowSma25() && isSma25BelowSma99();
  }
}
