import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> launchUrlString(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint('Ошибка при открытии ссылки: $e');
    }
  }

  static List<TextSpan> buildTextWithClickableLinks(String text) {
    final List<TextSpan> textSpans = [];
    final RegExp urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;

    for (final Match match in urlRegExp.allMatches(text)) {
      // Добавляем обычный текст до ссылки
      if (match.start > lastMatchEnd) {
        textSpans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(
            color: Color.fromRGBO(1, 57, 104, 1),
            fontSize: 18,
          ),
        ));
      }

      // Добавляем кликабельную ссылку
      final String url = match.group(0)!;
      textSpans.add(TextSpan(
        text: url,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 18,
        ),
        recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(url),
      ));

      lastMatchEnd = match.end;
    }

    // Добавляем оставшийся текст после последней ссылки
    if (lastMatchEnd < text.length) {
      textSpans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(
          color: Color.fromRGBO(1, 57, 104, 1),
          fontSize: 18,
        ),
      ));
    }

    return textSpans;
  }
} 