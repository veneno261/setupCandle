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
