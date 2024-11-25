import 'package:http/http.dart' as http;

Future<http.Response> fetchMarketData({
  required String tokenName,
  required String tokenConvert,
  required String timeFrame,
  required String candleLimit,
  required String exchange,
  required String dhm,
}) async {
  final String apiKey = 'cae0f9c4df9dd25e84d1150d182fc2cfa73caff6f415f463990c1c44ae05691d';
  final String url =
      'https://min-api.cryptocompare.com/data/v2/$dhm?fsym=$tokenName&tsym=$tokenConvert&limit=$candleLimit&e=$exchange&aggregate=$timeFrame';

  try {
    return await http.get(Uri.parse(url), headers: {
      'Authorization': 'Apikey $apiKey',
    });
  } catch (e) {
    print('Exception: $e');
    return http.Response('', 261);
    //throw Exception('Failed to fetch market data');
  }
}
