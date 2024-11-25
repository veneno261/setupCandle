class BotMessageTemplate {
  final String tokenName;
  final String timeFrame;
  final String candle;
  final String signal;
  //final String chartLink;

  BotMessageTemplate({
    required this.tokenName,
    required this.timeFrame,
    required this.candle,
    required this.signal,
  });

  @override
  String toString() {
    return """
    *************** 🤑 ${tokenName.toUpperCase()} 🤑 ***************
Time Frame: $timeFrame ⏰
Direction: $signal
Candle: $candle
    """;
  }
}
