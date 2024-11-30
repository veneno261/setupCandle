import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartImgApi {
  final String apiKey = '1FLRgWdVi12sSEMNZq7qt8an3b7Om4Ce5gUo8fsu';
  static const String baseUrl = 'https://api.chart-img.com/v2/tradingview/advanced-chart';

  /// Fetch chart image for a specific symbol from Binance.
  Future<http.Response> getChartImage({
    required String symbol,
    required String interval,
    int width = 800,
    int height = 600,
    String style = 'candle',
    String theme = 'dark',
  }) async {
    final uri = Uri.parse(baseUrl);
    final headers = {
      'x-api-key': apiKey,
      'content-type': 'application/json',
    };
    final body = {
      'symbol': 'BINANCE:$symbol',
      'interval': interval,
      'width': width.toString(),
      'height': height.toString(),
      'style': style,
      'theme': theme,
      'scale': 'logarithmic',
      'studies':  [
    {
      "name": "Moving Average Multiple",
      "input": {
        "firstPeriods": 7,
        "secondPeriods": 25,
        "thirdPeriods": 99,
       // "fourthPeriods": 50,
       // "fifthPeriods": 100,
       // "sixthPeriods": 200,
        "method": "Simple"
      },
      "override": {
        "Plot 1.linewidth": 1,
        "Plot 1.plottype": "line",
        "Plot 1.color": "rgb(156,39,176)",
        "Plot 2.linewidth": 1,
        "Plot 2.plottype": "line",
        "Plot 2.color": "rgb(255,109,0)",
        "Plot 3.linewidth": 1,
        "Plot 3.plottype": "line",
        "Plot 3.color": "rgb(67,160,71)",
       // "Plot 4.linewidth": 1,
        //"Plot 4.plottype": "line",
        //"Plot 4.color": "rgb(38,198,218)",
       // "Plot 5.linewidth": 1,
       // "Plot 5.plottype": "line",
       // "Plot 5.color": "rgb(245,0,87)",
       // "Plot 6.linewidth": 1,
       // "Plot 6.plottype": "line",
       // "Plot 6.color": "rgb(33,150,243)"
      }
    }
  ]
    };

    try {
      return await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
    } catch (e) {
      print('Exception: $e');
      return http.Response('', 261);
    }
  }
}
