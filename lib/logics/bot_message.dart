import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramBot {
  Future<void> sendMessage({
    required String message,
    http.MultipartFile? chartImg,
  }) async {
    final response;
    final responseBody;
    final url_send_message = 'https://nodejs-w8xcuv.chbk.app/send_message';
    final url_send_chart = 'https://nodejs-w8xcuv.chbk.app/send_chart';

    try {
      if (chartImg != null) {
        final request = await http.MultipartRequest(
          'POST',
          Uri.parse(url_send_chart),
        )
          ..fields['caption'] = message
          ..files.add(chartImg);
        response = await request.send();
        responseBody = await http.Response.fromStream(response);
        print(responseBody.body);
      } else {
        response = await http.post(
          Uri.parse(url_send_message),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"message": message}),
        );
      }

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
