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

Chart : <a href="https://www.tradingview.com/symbols/BINANCE:${tokenName.toUpperCase()}USDT/">Open Chart</a>

<code>${tokenName.toUpperCase()}USDT</code> Click to copy
    """;
  }
}
