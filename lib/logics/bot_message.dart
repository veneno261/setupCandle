import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramBot {
  final String botToken;
  final String chatId;

  TelegramBot(this.botToken, this.chatId);

  Future<void> sendMessage(String message) async {
    final url = 'https://api.telegram.org/bot$botToken/sendMessage';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chat_id': chatId,
        'text': message,
      }),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
