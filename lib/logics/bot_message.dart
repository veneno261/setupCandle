import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramBot {
  Future<void> sendMessage(String message) async {
    final url = 'https://nodejs-w8xcuv.chbk.app/send_message';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
