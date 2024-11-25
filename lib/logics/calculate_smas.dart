// تابع برای دریافت قیمت‌های بسته شدن از پاسخ API
List<double> getClosePrices(Map<String, dynamic> response) {
  final data = response['Data']['Data'];
  return data.map<double>((candle) => (candle['close'] as num).toDouble()).toList();
}

// تابع برای محاسبه EMA با تعداد دوره‌های مشخص
double calculateEMA(List<double> closePrices, int period) {
  if (closePrices.length < period) {
    throw Exception("Not enough data to calculate EMA");
  }

  final double k = 2 / (period + 1);
  double ema = closePrices.sublist(0, period).reduce((a, b) => a + b) / period;

  for (int i = period; i < closePrices.length; i++) {
    ema = (closePrices[i] * k) + (ema * (1 - k));
  }

  return ema;
}

// تابع برای محاسبه SMA با تعداد دوره‌های مشخص
List<double> calculateSMA(List<double> closePrices, int period) {
  if (closePrices.length < period) {
    throw Exception("Not enough data to calculate SMA");
  }

  List<double> smaValues = [];

  for (int i = 0; i <= closePrices.length - period; i++) {
    double sum = closePrices.sublist(i, i + period).reduce((a, b) => a + b);
    smaValues.add(sum / period);
  }

  return smaValues;
}

List<List<double>> calculateSMAs(Map<String, dynamic> apiResponse) {
  // دریافت قیمت‌های بسته شدن
  List<double> closePrices = getClosePrices(apiResponse);

  // محاسبه SMA برای دوره‌های مختلف
  List<double> sma7 = calculateSMA(closePrices, 7);
  List<double> sma25 = calculateSMA(closePrices, 25);
  List<double> sma99 = calculateSMA(closePrices, 99);

  // print('SMA 7: ${sma7.last}');
  // print('SMA 25: ${sma25.last}');
  // print('SMA 25: ${sma25[sma25.length - 3]}');
  // print('SMA 99: ${sma99.last}');

  return [
    sma7,
    sma25,
    sma99,
  ];
}
