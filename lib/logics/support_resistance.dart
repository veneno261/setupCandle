List<List<double>> findSupportResistance(List<Map<String, dynamic>> ohlcData, int lookBack) {
  List<double> resistanceLevels = [];
  List<double> supportLevels = [];

  for (int i = lookBack; i < ohlcData.length - lookBack; i++) {
    // Check for swing high using close prices
    bool isResistance = true;
    for (int j = 1; j <= lookBack; j++) {
      if (ohlcData[i]['close'] <= ohlcData[i - j]['close'] || ohlcData[i]['close'] <= ohlcData[i + j]['close']) {
        isResistance = false;
        break;
      }
    }
    if (isResistance) {
      resistanceLevels.add(ohlcData[i]['close']);
    }

    // Check for swing low using open prices
    bool isSupport = true;
    for (int j = 1; j <= lookBack; j++) {
      if (ohlcData[i]['open'] >= ohlcData[i - j]['open'] || ohlcData[i]['open'] >= ohlcData[i + j]['open']) {
        isSupport = false;
        break;
      }
    }
    if (isSupport) {
      supportLevels.add(ohlcData[i]['open']);
    }
  }

  return [supportLevels, resistanceLevels];
}

void main() {
  List<Map<String, dynamic>> ohlcData = [
    {
      'time': 1730347200,
      'close': 0.689,
      'high': 0.69,
      'low': 0.684,
      'open': 0.6865,
      'volumefrom': 820410,
      'volumeto': 563625.87,
      'conversionType': 'force_direct',
      'conversionSymbol': ''
    },
    {
      'time': 1730350800,
      'close': 0.6892,
      'high': 0.6934,
      'low': 0.6875,
      'open': 0.689,
      'volumefrom': 613747,
      'volumeto': 424017.76,
      'conversionType': 'force_direct',
      'conversionSymbol': ''
    },
    // Add more OHLC data here
  ];

  int lookBack = 2; // Set the number of candles to look back and ahead for swing detection
  List<List<double>> supportResistanceLevels = findSupportResistance(ohlcData, lookBack);

  print("Support Levels: ${supportResistanceLevels[0]}");
  print("Resistance Levels: ${supportResistanceLevels[1]}");
}
