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
<b>🤑 #${tokenName.toUpperCase()} 🤑</b>

Time Frame: $timeFrame ⏰

Direction: $signal

Candle: $candle

Link : <a href="https://www.tradingview.com/symbols/BINANCE:${tokenName.toUpperCase()}USDT/">${tokenName.toUpperCase()}/USDT chart</a>
    """;
  }
}
