// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class TelegramBot {
//   Future<void> sendMessage({
//     required String message,
//     http.MultipartFile? chartImg,
//   }) async {
//     final response;
//     final responseBody;
//     final url_send_message = 'https://nodejs-w8xcuv.chbk.app/send_message';
//     final url_send_chart = 'https://nodejs-w8xcuv.chbk.app/send_chart';

//     try {
//       if (chartImg != null) {
//         final request = await http.MultipartRequest(
//           'POST',
//           Uri.parse(url_send_chart),
//         )
//           ..fields['caption'] = message
//           ..files.add(chartImg);
//         response = await request.send();
//         responseBody = await http.Response.fromStream(response);
//         print(responseBody.body);
//       } else {
//         response = await http.post(
//           Uri.parse(url_send_message),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({"message": message}),
//         );
//       }

//       if (response.statusCode == 200) {
//         print('Message sent successfully');
//       } else {
//         print('Failed to send message: ${response}');
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TelegramBotMessenger {
  final String botToken = "8159444945:AAFREaeS7veuvpiG_oFDEogcQASvBJSpU78";
  final String pvChatId = "60596350";

  TelegramBotMessenger();

  /// Sends a text message with HTML formatting.
  Future<void> sendTextMessage({required String message, String? chatId}) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId ?? pvChatId,
          'text': message,
          'parse_mode': 'HTML',
        }),
      );

      if (response.statusCode != 200) {
        throw HttpException('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error sending text message: $e');
    }
  }

  /// Sends an image with a caption using HTML formatting.
  Future<void> sendImageWithCaption({required http.MultipartFile image, required String caption, String? chatId}) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendPhoto');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['chat_id'] = chatId ?? pvChatId
        ..fields['caption'] = caption
        ..fields['parse_mode'] = 'HTML'
        ..files.add(image);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw HttpException('Failed to send image: ${response.body}');
      }
    } catch (e) {
      print('Error sending image with caption: $e');
    }
  }
}
