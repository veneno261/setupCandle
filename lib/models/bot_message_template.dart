import 'package:http/http.dart' as http;

class BotMessageTemplate {
  final String tokenName;
  final String timeFrame;
  final String candle;
  final String signal;

  BotMessageTemplate({
    required this.tokenName,
    required this.timeFrame,
    required this.candle,
    required this.signal,
  });

  @override
  String toString() {
    return """
***************🤑 ${tokenName.toUpperCase()} 🤑***************
Time Frame: $timeFrame ⏰

Direction: $signal

Candle: $candle

Link : [Go to chart](https://www.tradingview.com/symbols/BINANCE:${tokenName.toUpperCase()}USDT/)
    """;
  }
}
